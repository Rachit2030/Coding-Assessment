const String geminiApiKey = '';

const String modelname = 'gemini-2.5-flash';

const List<String> generalReplies = [
    "Hello! How can I assist you today?", "I see, please tell me more.",
    "Thanks for reaching out!", "I'm here to help you.", "Could you clarify that?",
    "Interesting, go on...", "Let me think about that...", "That's a good question!",
    "I understand, please continue.",
  ];

  const Map<String, String> keywordReplies = {
    "hello": "Hi there! How can I help?", "help": "Sure! What do you need assistance with?",
    "issue": "I'm sorry to hear that. Can you describe the issue?", 
    "thanks": "You're welcome!", "bye": "Goodbye! Have a nice day.",
  };

  const List<String> imageReplies = [
    "Nice photo! 📸", "Cool picture! 😍", "Great shot! 👏", 
    "Beautiful! ✨", "Love this! ❤️",
  ];

  const List<String> emojiReplies = [
    "😊 That's awesome!", "😂 Haha nice one!", "🤔 Interesting choice!",
    "🥰 Love this emoji!", "👍 Perfect!", "🔥 Fire emoji!", "⭐ Great pick!",
  ];


  const String androidWebviewURL = "http://10.0.2.2:4200";
  const String iosWebviewURL = "http://localhost:4200";