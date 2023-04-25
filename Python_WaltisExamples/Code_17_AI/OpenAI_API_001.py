import openai

part1 ='sk-uyTqACNqeZcChoaYBtv9'
part2 ='T3BlbkFJNKYwbeIv6EUCGBAlBvMN'
waltisOpenAI_Key = part1 + part2
openai.api_key = waltisOpenAI_Key


def generate_response(prompt):
    # Send the request to the API
    response = openai.Completion.create(
        engine="text-davinci-002",
        prompt=prompt,
        max_tokens=1024,
        temperature=0.5
    )

    # Return the generated text
    return response["choices"][0]["text"]

# USAGE
user_input = "Do you know HWZ and how close is it to the main station"
# user_input = "Generiere mir ein Beispiel für Listen Bearbeitungen in Python"
bot_response = generate_response(user_input)
print(bot_response)

