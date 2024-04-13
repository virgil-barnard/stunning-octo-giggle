from dotenv import load_dotenv
load_dotenv()

from crewai import Crew

from tasks import GameTasks
from agents import GameAgents

OPENAI_API_BASE='http://localhost:11434/v1'
OPENAI_MODEL_NAME='mistral'  # Adjust based on available model
OPENAI_API_KEY='123'

import os

os.environ["OPENAI_API_KEY"]=OPENAI_API_KEY
os.environ["OPENAI_MODEL_NAME"]=OPENAI_MODEL_NAME
os.environ["OPENAI_API_BASE"]=OPENAI_API_BASE

tasks = GameTasks()
agents = GameAgents()

print("## Welcome to the Game Crew")
print('-------------------------------')
game = input("What is the game you would like to build? What will be the mechanics?\n")

# Create Agents
senior_engineer_agent = agents.senior_engineer_agent()
qa_engineer_agent = agents.qa_engineer_agent()
chief_qa_engineer_agent = agents.chief_qa_engineer_agent()

# Create Tasks
code_game = tasks.code_task(senior_engineer_agent, game)
review_game = tasks.review_task(qa_engineer_agent, game)
approve_game = tasks.evaluate_task(chief_qa_engineer_agent, game)

# Create Crew responsible for Copy
crew = Crew(
	agents=[
		senior_engineer_agent,
		qa_engineer_agent,
		chief_qa_engineer_agent
	],
	tasks=[
		code_game,
		review_game,
		approve_game
	],
	verbose=True
)

game = crew.kickoff()

'''
A Snake game. The snake should die when it hits the boundry of the map. The score should be shown in the top right corner. The background should be black. The snake should be white. The food should be green. Food should be randomly placed every time the snake eats one. The player should be able to control the snake with arrow keys.
'''

# Print results
print("\n\n########################")
print("## Here is the result")
print("########################\n")
print("final code for the game:")
print(game)