---@diagnostic disable: lowercase-global

name = "Don't Starve Neuro"
version = "0.0.0"
author = "EthLeigh"
description = "Allows Neuro-sama (or Evil) to play Don't Starve."

dont_starve_compatible = true
dst_compatible = false
all_clients_require_mod = false
client_only_mod = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
hamlet_compatible = true

api_version = 6
api_version_dst = 10

forumthread = ""
priority = 0

configuration_options =
{
    {
        name = "goals_enabled",
        label = "Goals Action",
        options =
        {
            { description = "Enabled",  data = true },
            { description = "Disabled", data = false },
        },
        default = true,
    },
}
