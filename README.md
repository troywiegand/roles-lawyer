# Roles Lawyer

A collection of Terraform and Discord bot to help manage a D&D Discord server run by a couple friends.

## Terraform Structure

All of the Terraform code lives in the `tf` directory.
One needs to supply the variable for the server ID you are managing.
There's also a few JSON files in the `tf/data` subdirectory that will hold the more influx aspects of the server like active campaigns, one-shots, and video games in active discussion.
These are broken out into JSON to make it easier for the Roles Lawyer Discord bot to process and edit these files based on the iteractions it has with the Server Admin.


## Discord Bot Structure

We are gonna use npm package `discord.js`.


## Deployment

For initial development effort, this is running on Troy's `Azorius` server and is ran against `Troy's Test Server` Discord Server.
We may want to scale to Cloud VM for higher dependability SLAs when this gets deployed to "production".
