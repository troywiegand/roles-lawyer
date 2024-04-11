locals {
  # get json 
  campaigns_data = {
    for index, c in jsondecode(file("${path.module}/data/campaigns.json")) :
    c.campaign_channel_grouping => merge({ archived = false }, c, { index = index })
  }
  filtered_data = {
    for index, c in jsondecode(file("${path.module}/data/campaigns.json")) :
    c.campaign_channel_grouping => merge({ archived = false }, c, { index = index }) if !lookup(c, "archived", false)
  }
  channels_data = {
    for index, c in local.filtered_data :
    c.campaign_channel_grouping => merge({ archived = false }, c, { index = index(keys(local.filtered_data), index) })
  }
}

resource "discord_category_channel" "campaign" {
  for_each  = local.channels_data
  name      = each.value.campaign_channel_grouping
  server_id = var.server_id
  position  = 1 + each.value.index ## Adding one to offset arcane eye
}

resource "discord_category_channel" "archived_campaigns" {
  name       = "Archived Campaigns"
  server_id  = var.server_id
  position   = length(local.channels_data)
  depends_on = [discord_category_channel.campaign]
}


resource "discord_text_channel" "general" {
  for_each  = local.campaigns_data
  name      = each.value.campaign_chat
  server_id = var.server_id
  category  = each.value.archived ? discord_category_channel.archived_campaigns.id : discord_category_channel.campaign[each.value.campaign_channel_grouping].id
  position  = 0
}

resource "discord_text_channel" "info" {
  for_each  = local.campaigns_data
  name      = each.value.campaign_info
  server_id = var.server_id
  category  = each.value.archived ? discord_category_channel.archived_campaigns.id : discord_category_channel.campaign[each.value.campaign_channel_grouping].id
  position  = 1
}

resource "discord_voice_channel" "general" {
  for_each  = local.channels_data
  name      = each.value.campaign_voice
  server_id = var.server_id
  category  = each.value.archived ? discord_category_channel.archived_campaigns.id : discord_category_channel.campaign[each.value.campaign_channel_grouping].id
  position  = 2
}


resource "discord_category_channel" "arcane_category" {
  name      = "💫 Order of the Arcane Eye"
  server_id = var.server_id
  position  = 0
}

resource "discord_voice_channel" "arcane_voice" {
  name      = "arcane-voice"
  server_id = var.server_id
  category  = discord_category_channel.arcane_category.id
}

resource "discord_text_channel" "arcane-general" {
  name      = "arcane-general"
  server_id = var.server_id
  category  = discord_category_channel.arcane_category.id
}
