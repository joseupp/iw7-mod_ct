Lobby = Lobby or {}
Lobby.MemberListStates = {
	Lobby = 2,
	Teams = 3
}
Lobby.MaxMemberListSlots = 18
Lobby.MemberListRefreshTime = 1000
Lobby.TransitionTime = 750
Lobby.MemberListMemberHeight = 26
Lobby.MemberListSquadMemberHeight = 25
Lobby.PasswordLength = 24
Lobby.DLC1_MAP_PACK_INDEX = 1
Lobby.DLC2_MAP_PACK_INDEX = 2
Lobby.DLC3_MAP_PACK_INDEX = 3
Lobby.DLC4_MAP_PACK_INDEX = 4
Lobby.MatchmakerState = {
	IDLE = 0,
	INITIALIZING = 1,
	SEARCHING = 2,
	QOSING = 3,
	JOINED_LOBBY = 4,
	ERRORING = 5
}
Lobby.PartyState = {
	NONE = 0,
	JOININGLOBBY = 1,
	MERGINGLOBBIES = 2,
	MIGRATINGHOSTS = 3,
	MAKEHOSTACTIVE = 4,
	WAITING_FOR_FASTFILES_STARTED = 5,
	WAITING_FOR_FASTFILES = 6,
	WAITING_FOR_MEMBERS = 7,
	WAITING_FOR_HOST_AWAY = 8,
	WAITING_FOR_HOST = 9,
	WAITING_FOR_MATCH = 10,
	WAITING_FOR_READY = 11,
	WAITING_FOR_OTHER_PLAYERS = 12,
	WAITING_FOR_DEDICATED_SERVER = 13,
	WAITING = 14,
	INTERMISSION = 15,
	HOST_CHANGING_SETTINGS = 16,
	SEARCHING_FOR_OPPONENTS = 17,
	MAKING_TEAMS = 18,
	STARTING_SOON = 19,
	STARTING = 20,
	UNKNOWN = 21
}
Lobby.GetStatusString = function ( f1_arg0 )
	if IsPublicMatch() then
		local f1_local0, f1_local1 = Lobby.GetPartyStatus() --GetMatchmakerStatus() vanilla, GetPartyStatus() offline
		if f1_local0 == Lobby.MatchmakerState.IDLE then
			return "", false, "idle"
		elseif f1_local0 == Lobby.MatchmakerState.JOINED_LOBBY then
			
		elseif f1_local0 == Lobby.MatchmakerState.QOSING then
			assert( f1_local1.numQoSPlayers )
			return Engine.Localize( "MPUI_MMING_QOSING", f1_local1.numQoSPlayers ), true, "qosing"
		elseif Lobby.IsPrivatePartyHost() then
			if f1_local0 == Lobby.MatchmakerState.INITIALIZING then
				return Engine.Localize( "MPUI_MMING_INITIALIZING" ), true, "initializing"
			elseif f1_local0 == Lobby.MatchmakerState.SEARCHING then
				return Engine.Localize( "MPUI_MMING_SEARCHING" ), true, "searching"
			elseif f1_local0 == Lobby.MatchmakerState.ERRORING then
				return Engine.Localize( "MPUI_MMING_ERRORING" ), true, "erroring"
			end
		end
	end
	local f1_local0, f1_local1 = Lobby.GetPartyStatus()
	if MLG.IsGameBattleMatch() then
		local f1_local2 = GAMEBATTLES.GetCurrentMatch( f1_arg0 )
		if f1_local2 then
			if f1_local0 == Lobby.PartyState.INTERMISSION then
				local f1_local3 = math.ceil( f1_local1.timeRemaining / 1000 )
				local f1_local4, f1_local5 = GAMEBATTLES.GetMatchProgressInfo( f1_local2 )
				if not f1_local5 then
					local f1_local6 = GAMEBATTLES.GetNoshowTime()
					if f1_local4 or f1_local3 < f1_local6 then
						return Engine.Localize( "MLG_GAMEBATTLES_STATUS_NOSHOW", Engine.MarkLocalized( Engine.FormatTimeHoursMinutesSeconds( f1_local3 ) ) ), false, "gamebattle_noshow"
					else
						return Engine.Localize( "MLG_GAMEBATTLES_STATUS_PREMATCH", Engine.MarkLocalized( Engine.FormatTimeHoursMinutesSeconds( f1_local3 - f1_local6 ) ) ), false, "gamebattle_prematch"
					end
				end
			else
				local f1_local3 = LUI.DataSourceInGlobalModel.new( "frontEnd.mlg.matchJoinState" )
				local f1_local4 = f1_local3:GetValue( f1_arg0 )
				if f1_local4 == GAMEBATTLES.MLG_MATCH_JOIN_STATE.IDLE or f1_local4 == GAMEBATTLES.MLG_MATCH_JOIN_STATE.TRY_CREATE then
					return "", false, "gamebattle_not joined"
				end
			end
		end
	end
	if f1_local0 == Lobby.PartyState.INTERMISSION then
		assert( f1_local1.timeRemaining )
		return Engine.Localize( "MENU_INTERMISSION", math.ceil( f1_local1.timeRemaining / 1000 ) ), false, "intermission"
	elseif f1_local0 == Lobby.PartyState.STARTING_SOON then
		return Engine.Localize( "MENU_MATCH_WILL_BEGIN" ), false, "starting_soon"
	elseif f1_local0 == Lobby.PartyState.STARTING then
		assert( f1_local1.timeRemaining )
		if f1_local1.timeRemaining < 0 then
			return Engine.Localize( "MENU_GAME_BEGINNING" ), false, "starting_no_time"
		else
			return Engine.Localize( "MENU_MATCH_BEGINNING_IN", math.ceil( f1_local1.timeRemaining / 1000 ) ), false, "starting"
		end
	elseif f1_local0 == Lobby.PartyState.WAITING_FOR_FASTFILES_STARTED then
		return Engine.Localize( "MENU_WAITING_FOR_FASTFILES_STARTED" ), true, "ff_started"
	elseif f1_local0 == Lobby.PartyState.WAITING_FOR_FASTFILES then
		return Engine.Localize( "MENU_WAITING_FOR_FASTFILES" ), true, "ff"
	elseif f1_local0 == Lobby.PartyState.WAITING_FOR_HOST then
		return Engine.Localize( "MENU_WAITING_FOR_HOST" ), false, "waiting_for_host"
	elseif f1_local0 == Lobby.PartyState.WAITING_FOR_READY then
		return Engine.Localize( "LUA_MENU_STATUS_NEED_TO_READY_UP" ), false, "waiting_for_ready"
	elseif f1_local0 == Lobby.PartyState.WAITING_FOR_OTHER_PLAYERS then
		return Engine.Localize( "LUA_MENU_STATUS_WAITING_FOR_OTHER_PLAYERS" ), false, "waiting_for_other_players"
	elseif f1_local0 == Lobby.PartyState.WAITING_FOR_DEDICATED_SERVER then
		return Engine.Localize( "MP_FRONTEND_ONLY_WAITING_FOR_DEDICATED_SERVER" ), true, "waiting_for_dedicated_server"
	elseif IsPublicMatch() then
		local f1_local2 = Engine.GetDvarInt( "party_minplayers" )
		local f1_local3 = Lobby.GetNumLobbyMembers()
		if f1_local3 < f1_local2 then
			return Engine.Localize( "MENU_WAITING_FOR_MORE_PLAYERS", f1_local2 - f1_local3 ), true, "waiting_for_players"
		end
	end
	if Lobby.IsPrivatePartyHost() then
		return Engine.Localize( "MENU_WAITING" ), false, "waiting"
	end
	return Engine.Localize( "MPUI_MMING_HOST_DOES_IT" ), true, "host_searching"
end
