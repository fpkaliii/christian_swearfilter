// i'm so sorry

local jesus = {}
if SERVER then
	util.AddNetworkString("jesus_msg")
	AddCSLuaFile("sh_jesusmod.lua")
	jesus.bibleAPI = "http://labs.bible.org/api/?passage="
	jesus.blasphemyVerses = {"Mark+3:29", "Matthew+12:31", "Matthew+9:3", "Luke+12:10"}
	jesus.swearVerses = {"Colossians+3:8", "Ephesians+4:29", "Matthew+15:11", "Proverbs+21:23", "Proverbs+4:24"}
	jesus.blasphemyWords = {"jesus christ", "jesus fucking christ", "oh god", "oh my god", "oh my fucking god"}
	jesus.swearWords = {"fuck", "shit", "ass", "fag", "cuck", "cock", "dick", "penis", "nig", "kys", "kill yourself", "kill urself", "lmao", "lmfao", "wtf", "gay", "sex", "secks"}
	jesus.sendQuote = function(target, blasphemy)
		local fullVerse = (blasphemy and table.Random(jesus.blasphemyVerses) or table.Random(jesus.swearVerses))
		local _start, _end = fullVerse:find("+", 1, true)
		local verseBook = fullVerse:sub(1, _start - 1)
		http.Fetch(jesus.bibleAPI .. fullVerse, function(body)
			local start1, end1 = body:find("<b>")
			local start2, end2 = body:find("</b>")
			local verseName = body:sub(end1 + 1, start2 - 1)
			local verseBody = body:sub(end2 + 1)
			local messageTable = {Color(255, 0, 0), "SINNER DETECTED! ", Color(255, 255, 255), "This type of language is intolerable on our christian server.\n", Color(255, 185, 0)}
			messageTable[#messageTable + 1] = verseBook .. " " .. verseName .. " - "
			messageTable[#messageTable + 1] = Color(255, 210, 25)
			messageTable[#messageTable + 1] = verseBody
			net.Start("jesus_msg")
			net.WriteTable(messageTable)
			net.Send(target)
		end)
	end

	jesus.playerSayHook = function(target, text, isTeam)
		for i = 1, #jesus.blasphemyWords do
			if text:lower():find(jesus.blasphemyWords[i]:lower()) then
				jesus.sendQuote(target, true)
				return ""
			end
		end

		for i = 1, #jesus.swearWords do
			if text:lower():find(jesus.swearWords[i]:lower()) then
				jesus.sendQuote(target, false)
				return ""
			end
		end
	end

	hook.Add("PlayerSay", "jesus.playerSayHook", jesus.playerSayHook)
else
	jesus.netHook = function()
		local garbage = net.ReadTable()
		chat.AddText(unpack(garbage))
	end

	net.Receive("jesus_msg", jesus.netHook)
end
