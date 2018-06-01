/*

Addon: That Free DarkRP Scoreboard (Checkout the HUD and F4 Addition!)
Purpose: For spreading the scoreboard love <3 ... for free :)
Author: Porky
Contact: Don't!

*/

PORKY_Scoreboard = PORKY_Scoreboard or {} // Don't fucking touch this you dumb fuck

////////////////// CONFIGURATION //////////////////
PORKY_Scoreboard.CommunityName = "Example Community"

// Colours!!! - Yes, a free scoreboard that let's you customize it completely!
PORKY_Scoreboard.ScoreboardOutline = Color(25,25,25,255) // Default: Color(25,25,25,255)
PORKY_Scoreboard.ScoreboardBackground = Color(45,45,45,255) // Default: Color(45,45,45,255)
PORKY_Scoreboard.CommunityNameColour = Color(230,230,230,255) // Default: Color(230,230,230,255)
PORKY_Scoreboard.HeaderColours = Color(200,200,200,255) // Default: Color(200,200,200,255)
PORKY_Scoreboard.ListBackground = Color(45,45,45,255) // Default: Color(45,45,45,255) (THIS IS THE THING BOX THAT IS BEHIND THE PLAYER ENTRIES)

// Colours!!! - For each additional player entry!
PORKY_Scoreboard.EntryOutline = Color(25,25,25,255) // Default: Color(25,25,25,255)
PORKY_Scoreboard.EntryBackground = Color(90,90,90,255) // Default: Color(90,90,90,255)

// Rank Colours!
PORKY_Scoreboard.UseULXRankColours = true // Default: true (If false, everyone will be the colour you specify below this!)
PORKY_Scoreboard.NOULXCOLOURS = Color(255,255,255,255) // Default: Color(255,255,255,255)
// Customize rank colours here :) One day I might make these pulse or flash :o
PORKY_Scoreboard.Ranks = {}
PORKY_Scoreboard.Ranks["user"] = Color(255,255,255,255)
PORKY_Scoreboard.Ranks["admin"] = Color(255,0,0,255)
PORKY_Scoreboard.Ranks["superadmin"] = Color(0,255,0,255)
PORKY_Scoreboard.Ranks["donator"] = Color(0,0,0,255) // lol


// It's best not to touch below here :)
// If you want to go ahead but I will not be fixing it for you if you fuck it, which you probably will...

surface.CreateFont("PS_Largest", {
	font = "Oswald",
	size = 90,
	weight = 500,
	antialias = true,
})
surface.CreateFont("PS_Large", {
	font = "Oswald",
	size = 64,
	weight = 500,
	antialias = true,
})
surface.CreateFont("PS_Small", {
	font = "Oswald",
	size = 32,
	weight = 500,
	antialias = true,
})
surface.CreateFont("PS_Tiny", {
	font = "Oswald",
	size = 24,
	weight = 500,
	antialias = true,
})


function PORKY_Scoreboard:show()
	// Let's create this scoreboard!
	gui.EnableScreenClicker(true)
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW() / 2 - 500, 100)
	frame:SetSize(1000, 750)
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	function frame:Paint(w,h)
		// Background Boxes
		draw.RoundedBox(5,0,0, w,h,PORKY_Scoreboard.ScoreboardOutline)
		draw.RoundedBox(5,5,5, w - 10,h - 10,PORKY_Scoreboard.ScoreboardBackground)
		// Community Title
		draw.SimpleText(PORKY_Scoreboard.CommunityName, "PS_Large", w / 2, 15, PORKY_Scoreboard.CommunityNameColour, TEXT_ALIGN_CENTER)
		// Description Background
		draw.RoundedBox(0,5,90, w - 10,25,Color(90,90,90,255))
		// Description Headers
		local curX = 7
		draw.SimpleText("Name", "PS_Small", curX, 87, PORKY_Scoreboard.HeaderColours, TEXT_ALIGN_LEFT) curX = curX + 390
		draw.SimpleText("Rank", "PS_Small", curX, 87, PORKY_Scoreboard.HeaderColours, TEXT_ALIGN_LEFT) curX = curX + 200
		draw.SimpleText("Kills", "PS_Small", curX, 87, PORKY_Scoreboard.HeaderColours, TEXT_ALIGN_LEFT) curX = curX + 150
		draw.SimpleText("Deaths", "PS_Small", curX, 87, PORKY_Scoreboard.HeaderColours, TEXT_ALIGN_LEFT) curX = curX + 150
		draw.SimpleText("Ping", "PS_Small", curX, 87, PORKY_Scoreboard.HeaderColours, TEXT_ALIGN_LEFT) curX = curX + 100
		// MAKESHIFT PROCEDURALLY GENERATED BUTTONS LMFAO
	end
	
	local player_list = vgui.Create("DListView", frame)
	player_list:SetSize(990, 630)
	player_list:SetPos(5, 115)
	player_list:SetMultiSelect( false )
	player_list:SetDataHeight( 35 )
	player_list:SetHideHeaders( true )
	player_list:AddColumn( "Name" ):SetFixedWidth( 390 )
	player_list:AddColumn( "Rank" ):SetFixedWidth( 200 )
	player_list:AddColumn( "Kills" ):SetFixedWidth( 150 )
	player_list:AddColumn( "Deaths" ):SetFixedWidth( 150 )
	player_list:AddColumn( "Ping" ):SetFixedWidth( 100 )// Maybe one day I will add utime support, but i cbf atm
	function player_list:Paint(w,h)
		draw.RoundedBox(0,0,0, w,h,PORKY_Scoreboard.ListBackground)
	end
	
	for k,v in pairs(player.GetAll()) do
		player_list:AddLine(v:Nick(), v:GetUserGroup(), v:GetNWInt("PORKY_KILLS"), v:Deaths(), v:Ping())
	end
	
	timer.Create("PORKY_Scoreboard_Update", 1, 0, function()
		if player_list then
			player_list:Clear()
			for k,v in pairs(player.GetAll()) do
				player_list:AddLine(v:Nick(), v:GetUserGroup(), v:GetNWInt("PORKY_KILLS"), v:Deaths(), v:Ping())
			end
			for k,v in pairs(player_list.Lines) do
				function v:Paint(w,h)
					draw.RoundedBox(0,0,0, w,h,PORKY_Scoreboard.EntryOutline)
			draw.RoundedBox(0,3.5,3, w - 7,h - 3,PORKY_Scoreboard.EntryBackground)
				end
				for id,pnl in pairs(v["Columns"]) do
					pnl:SetFont("PS_Small")
					if PORKY_Scoreboard.UseULXRankColours then
						pnl:SetTextColor(PORKY_Scoreboard.Ranks[v:GetColumnText(2)] or Color(255,255,255,255))
					else
						pnl:SetTextColor(PORKY_Scoreboard.NOULXCOLOURS)
					end
				end
			end
		end
	end)
	
	for k,v in pairs(player_list.Lines) do
		function v:Paint(w,h)
			draw.RoundedBox(0,0,0, w,h,PORKY_Scoreboard.EntryOutline)
			draw.RoundedBox(0,3.5,3, w - 7,h - 3,PORKY_Scoreboard.EntryBackground)
		end
		for id,pnl in pairs(v["Columns"]) do
			pnl:SetFont("PS_Small")
			if PORKY_Scoreboard.UseULXRankColours then
				pnl:SetTextColor(PORKY_Scoreboard.Ranks[v:GetColumnText(2)] or Color(255,255,255,255)) // If we have not configured this rank then we will just make it white?
			else
				pnl:SetTextColor(PORKY_Scoreboard.NOULXCOLOURS)
			end
		end
	end
	
	
	// do I comment my code too much?
	
	function PORKY_Scoreboard:hide()
		frame:Remove()
		timer.Destroy("PORKY_Scoreboard_Update") // Prevent those errors
		gui.EnableScreenClicker(false)
	end
end

// CL hooks - Do not touch

hook.Add("ScoreboardShow", "PORKY_Scoreboard_Show_HOOK", function()
	PORKY_Scoreboard:show()
	return true // Don't draw the default scoreboard... ew
end)

hook.Add("ScoreboardHide", "PORKY_Scoreboard_Hide_HOOK", function()
	PORKY_Scoreboard:hide()
	// Am I meant to do something here lmao
end)
