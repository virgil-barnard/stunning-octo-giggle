#%matplotlib qt
import matplotlib.pyplot as plt
import numpy as np
import time
import pyaudio
from scipy import signal
from scipy.fftpack import fft
from scipy.signal import lfilter
from scipy.signal import get_window
from scipy.signal import resample
import scipy
class LowPassFilter:
    def __init__(self, tau, ts):
        self.a = 1. / (tau / ts + 1.)
        self.b = tau / ts / (tau / ts + 1.);
        self.last_val = 0.
        
    def filter(self, val):
        self.last_val = self.a * val + self.b * self.last_val
        return self.last_val
    
lpf = LowPassFilter(0.1, 0.1)

from scipy.signal import butter, filtfilt

def bandpass_filter(data, fs, lowcut, highcut):
    """
    Apply a Butterworth bandpass filter to the input data.
    """
    # Calculate filter coefficients
    b, a = butter(5, [lowcut/(0.5*fs), highcut/(0.5*fs)], btype='band')
    # Apply the filter
    filtered_data = filtfilt(b, a, data)
    return filtered_data

def hz2mel(hz):
    """Convert a frequency from Hertz to Mels."""
    return 1127.01048 * np.log(hz / 700 + 1)

def mel2hz(mel):
    """Convert a frequency from Mels to Hertz."""
    return 700 * (np.exp(mel / 1127.01048) - 1)

plt.ion() # Stop matplotlib windows from blocking

# Set the length of time to display in the animation (in seconds)
time_length = 10

# Set the number of samples per second (sampling rate)
sampling_rate = 44100

# Calculate the number of samples to display in the animation
num_samples = time_length * 10

# Set the number of Mel filters to use
num_mel_filters = 40

# Set the low and high frequencies of the Mel filters (in Hz)
low_freq = 0
high_freq = sampling_rate / 2

# Calculate the Mel filterbank matrix
# mel_filters = np.zeros((num_mel_filters, int(1024/2)+1))
# freqs = np.linspace(0, sampling_rate/2, int(1024/2)+1)

fft_size = int(2**12)

# Setup figure, axis and initiate plot
fig, ax = plt.subplots()

# Initialize PyAudio object
p = pyaudio.PyAudio()

# Open a stream to read audio from the microphone
stream = p.open(format=pyaudio.paInt16, channels=1, rate=sampling_rate, input=True, frames_per_buffer=1024)

# Initialize the time array to display in the animation
t = np.arange(num_samples)

# Initialize the spectrogram data array
spec_data = np.zeros((fft_size,num_samples))




while True:
    # Read audio data from the microphone
    stream.start_stream()
    data = np.frombuffer(stream.read(fft_size), dtype=np.int16)
    stream.stop_stream()
    
    data = filtered_values = [lpf.filter(x) for x in data]
#     data = bandpass_filter(data, sampling_rate, 40, 3000)
    data = bandpass_filter(data, sampling_rate, 3000, 5000)
#     data = bandpass_filter(data, sampling_rate, 6000, 20000)
    # Perform FFT on the audio data
    fft_data = np.abs(fft(scipy.fft.ifftshift(data)))
    fft_data = np.fft.fftshift(fft_data)
    fft_data = np.log(np.abs(fft_data))
    spec_data = np.roll(spec_data,-1)
    spec_data[:,-1]=fft_data
    mean = np.mean(spec_data[:,-1])
    spec_data[mean>spec_data]=0

    # Clear the axis
    ax.clear()
    
    # Plot the Mel spectrogram data
    ax.imshow(np.rot90(np.array(spec_data)), aspect='auto', extent=[0,  fft_size, num_samples,0], cmap='inferno')
    
    # Update the window
    fig.canvas.draw()
    fig.canvas.flush_events()

# Close the stream and terminate PyAudio
stream.close()
p.terminate()
