hook.Add("PlayerInitialSpawn", "PORKY_Scoreboard_SetupKillsDeaths", function(ply)
	ply:SetNWInt("PORKY_KILLS", 0)
end)

hook.Add("PlayerDeath", "PORKY_Scoreboard_Death", function(victim, inflictor, attacker)
	if attacker:IsPlayer() then attacker:SetNWInt("PORKY_KILLS", attacker:GetNWInt("PORKY_KILLS") + 1) end
end)

// in the future there will be some analytic stuff going on here. I like to track you all and steal ur personal information :)
// Don't consider it a backdoor but a way that I can see what countries use my script, what kind of servers are using it.
// Not implemented yet but in the future :Don

// Also thanks for using this scoreboard <3 <3 <3 <3 <3 <3 <3