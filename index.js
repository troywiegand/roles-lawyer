// Require the necessary discord.js classes
const { ActionRowBuilder, Client, Events, GatewayIntentBits, ModalBuilder, TextInputBuilder, TextInputStyle } = require('discord.js');
const dotenv = require('dotenv');

dotenv.config()

// Create a new client instance
const client = new Client({ intents: [GatewayIntentBits.Guilds] });

// When the client is ready, run this code (only once).
// The distinction between `client: Client<boolean>` and `readyClient: Client<true>` is important for TypeScript developers.
// It makes some properties non-nullable.
client.once(Events.ClientReady, readyClient => {
	console.log(`Ready! Logged in as ${readyClient.user.tag}`);
});


client.on(Events.InteractionCreate, async interaction => {
//	if (!interaction.isChatInputCommand()) return;
	console.log(interaction);

		if (interaction.commandName === 'modal') {
		const modal = new ModalBuilder()
			.setCustomId('myModal')
			.setTitle('My Modal');

		// TODO: Add components to modal...
	        // Create the text input components
		const favoriteColorInput = new TextInputBuilder()
			.setCustomId('favoriteColorInput')
		    // The label is the prompt the user sees for this input
			.setLabel("What's your favorite color?")
		    // Short means only a single line of text
			.setStyle(TextInputStyle.Short);

		const hobbiesInput = new TextInputBuilder()
			.setCustomId('hobbiesInput')
			.setLabel("What's some of your favorite hobbies?")
		    // Paragraph means multiple lines of text.
			.setStyle(TextInputStyle.Paragraph);

		// An action row only holds one text input,
		// so you need one action row per text input.
		const firstActionRow = new ActionRowBuilder().addComponents(favoriteColorInput);
		const secondActionRow = new ActionRowBuilder().addComponents(hobbiesInput);

		// Add inputs to the modal
		modal.addComponents(firstActionRow, secondActionRow);

		// Show the modal to the user
		await interaction.showModal(modal);
	}
});

client.on(Events.InteractionCreate, async interaction => {
	if (!interaction.isModalSubmit()) return;

	if (interaction.customId === 'myModal') {
	// Get the data entered by the user
	const favoriteColor = interaction.fields.getTextInputValue('favoriteColorInput');
	const hobbies = interaction.fields.getTextInputValue('hobbiesInput');
	console.log({ favoriteColor, hobbies });
		await interaction.reply({ content: 'Your submission was received successfully!' });
	}

});

// Log in to Discord with your client's token
client.login(process.env.DISCORD_BOT_TOKEN);
