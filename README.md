# stunning-octo-giggle

## Environment Setup Guide

This guide will walk you through setting up a Python environment and installing necessary packages using pip on both Windows and Ubuntu.

### Prerequisites

Before you begin, make sure you have Python and pip installed on your system. If you're using Windows, you'll need to download and install Python from the [official website](https://www.python.org/downloads/). If you're using Ubuntu, Python is usually pre-installed. You can check by opening a terminal and running:

```bash
python3 --version
```

If Python is not installed, you can install it using:

```bash
sudo apt update
sudo apt install python3
```

Pip is usually installed by default with Python. You can check if pip is installed by running:

```bash
pip3 --version
```

### Setup Instructions

1. **Clone the Repository:**

   ```bash
   git clone <repository_url>
   cd <repository_name>
   ```

2. **Create a Virtual Environment (Optional but Recommended):**

   It's recommended to create a virtual environment to isolate your project dependencies.

   #### For Windows:

   ```bash
   # Install virtualenv if you haven't already
   pip install virtualenv

   # Create a virtual environment
   virtualenv my_env

   # Activate the virtual environment
   my_env\Scripts\activate
   ```

   #### For Ubuntu:

   ```bash
   # Install virtualenv if you haven't already
   sudo apt install python3-venv

   # Create a virtual environment
   python3 -m venv my_env

   # Activate the virtual environment
   source my_env/bin/activate
   ```

3. **Install Python Packages:**

   Inside your project directory, install the required packages using pip. You can do this by creating a `requirements.txt` file with the required packages and running:

   ```bash
   pip install -r requirements.txt
   ```
   
4. **Install Ollama for local LLM's:**

   #### For Ubuntu:

   ```bash
   sudo curl -fsSL https://ollama.com/install.sh | sh
   ```

   #### For Windows:

   https://ollama.com/download/windows

6. **Additional Notes:**

   - Make sure to replace `<repository_url>` and `<repository_name>` with the actual URL and name of your repository.
   - Using a virtual environment is recommended to avoid conflicts with system-wide Python packages.
   - You can install additional packages later using `pip install <package_name>` or by adding them to your `requirements.txt` file and running `pip install -r requirements.txt`.
  
7. **For speak:**
   sudo apt install espeak

That's it! You now have a Python environment set up and ready for your project. Happy coding!
