return {
	["misc"] = {
		["dictionary"] = {
			["k_ccc_what"] = "???",
			["k_ccc_secret"] = "Secret",
			
			["k_ccc_a_jslot"] = "+1 Joker Slot",
			["k_ccc_a_pack"] = "+1 Pack",
			["k_ccc_applied"] = "Applied",
			["k_ccc_broken"] = "Broken",
			["k_ccc_correct"] = "Correct",
			["k_ccc_discarded"] = "Discarded",
			["k_ccc_equal"] = "Equal",
			["k_ccc_fire"] = "Fire",
			["k_ccc_incorrect"] = "Incorrect",
			["k_ccc_redraw"] = "Redraw",
			["k_ccc_reset"] = "Reset",
			["k_ccc_steel"] = "Steel",
			["k_ccc_swapped"] = "Swapped",
			["k_ccc_upgraded"] = "Upgraded",
			
			["k_ccc_active_ex"] = "Active!",
			["k_ccc_fire_ex"] = "Fire!",
			["k_ccc_prevent_ex"] = "Prevent!",
			["k_ccc_standard_ex"] = "Standard!",
			["k_ccc_strawberry_ex"] = "Strawberry!",
			
			["k_ccc_safe_eq"] = "Safe..?",
		},
		["v_dictionary"] = {
			["ccc_a_ante_minus"] = "-#1# Ante",
			["ccc_a_discard"] = "+#1# Discard",
			["ccc_a_cards"] = "+#1# Cards",
			["ccc_a_card"] = "+#1# Card",
			["ccc_hardlist_star"] = "#1#-Star!",
		},
		["labels"] = {
			["k_ccc_secret"] = "Secret",
			["ccc_mirrored"] = "Mirrored",
			["k_ccc_what"] = "???",
			["k_ccc_strawberry_badge"] = "Strawberry",
		},
	},
	["descriptions"] = {
		["Back"] = {
			["b_ccc_summit"] = {
				["name"] = "Summit Deck",
				["text"] = {
					"{C:attention}-4{} Joker slots",
					"{C:attention}+1{} Joker slot each Ante",
					"without a {C:red}final boss{}",
					"{s:0.75}(if Ante has not been reached before){}",
				},
			},
			["b_ccc_virus"] = {
				["name"] = "Virus Deck",
				["text"] = {
					"Each played card is retriggered",
					"then {C:red}debuffed{}",
					"until the end of the ante",
				},
			},
			["b_ccc_heartside"] = {
				["name"] = "Heartside Deck",
				["text"] = {
					"Only {C:attention}Modded{} Jokers may appear",
					"{s:0.75}(and maybe {C:legendary,E:1,s:0.75}jimbo{}{s:0.75})",
				},
			},
			["b_ccc_bside"] = {
				["name"] = "B-Side Deck",
				["text"] = {
					"Every blind is a {C:red}boss blind{}",
					"Start from {C:attention}Ante 0{}",
					"Skipping costs {C:red}$8{} multiplied",
					"by ({C:attention}Current Ante{} + {C:attention}1{})",
				},
			},
		},
		["Sleeve"] = {
			["sleeve_ccc_bside"] = {
				["name"] = "B-Side Sleeve",
				["text"] = {
					"Every blind is a {C:red}boss blind{}",
					"Start from {C:attention}Ante 0{}",
					"Skipping costs {C:red}$8{} multiplied",
					"by ({C:attention}Current Ante{} + {C:attention}1{})",
				},
			},
			["sleeve_ccc_bside_alt"] = {
				["name"] = "B-Side Sleeve",
				["text"] = {
					"Every blind is {C:red}partnered{}",
					"Start with {C:blue,T:v_grabber}Grabber{}, {C:red,T:v_wasteful}Wasteful{}, and {C:attention,T:v_blank}Blank{}",
				},
			},
			["sleeve_ccc_virus"] = {
				["name"] = "Virus Sleeve",
				["text"] = {
					"Each played card is retriggered",
					"then {C:red}debuffed{}",
					"until the end of the ante",
				},
			},
			["sleeve_ccc_virus_alt"] = {
				["name"] = "Virus Sleeve",
				["text"] = {
					"Each played card is retriggered",
					"then {C:red}debuffed{}",
					"until the end of the ante",
--					"Each played card is retriggered twice",
--					"All drawn cards are {C:red}debuffed{}",
--					"until the end of the ante",
				},
			},
			["sleeve_ccc_summit"] = {
				["name"] = "Summit Sleeve",
				["text"] = {
					"{C:attention}-4{} Joker slots",
					"{C:attention}+1{} Joker slot each Ante",
					"without a {C:red}final boss{}",
					"{s:0.75}(if Ante has not been reached before){}",
				},
			},
			["sleeve_ccc_summit_alt"] = {
				["name"] = "Summit Sleeve",
				["text"] = {
					"You win only upon defeating Ante 16",
				},
			},
			["sleeve_ccc_heartside"] = {
				["name"] = "Heartside Sleeve",
				["text"] = {
					"Only {C:attention}Modded{} Jokers may appear",
					"{s:0.75}(and maybe {C:legendary,E:1,s:0.75}jimbo{}{s:0.75})"
				},
			},
		},
		["Blind"] = {
			["bl_ccc_crystal"] = {
				["name"] = "The Crystal",
				["text"] = {
					"All Diamonds are",
					"drawn face down",
				},
			},
			["bl_ccc_snow"] = {
				["name"] = "The Snow",
				["text"] = {
					"All Clubs are",
					"drawn face down",
				},
			},
			["bl_ccc_shriek"] = {
				["name"] = "The Shriek",
				["text"] = {
					"Cards held in hand",
					"debuffed after hand played",
				},
			},
			["bl_ccc_goldencrown"] = {
				["name"] = "Golden Crown",
				["text"] = {
					"Defeat this blind",
					"#1# time#2#",
				},
			},
			["bl_ccc_fallacy"] = {
				["name"] = "The Fallacy",
				["text"] = {
					"Playing cards lose",
					"a rank when played",
				},
			},
			["bl_ccc_stone"] = {
				["name"] = "The Stone",
				["text"] = {
					"All Spades are",
					"drawn face down",
				},
			},
			["bl_ccc_gap"] = {
				["name"] = "The Gap",
				["text"] = {
					"Every other played",
					"card is debuffed",
				},
			},
			["bl_ccc_berry"] = {
				["name"] = "The Berry",
				["text"] = {
					"All Hearts are",
					"drawn face down",
				},
			},
		},
		["Other"] = {
			["e_mirrored"] = {
				["name"] = "Mirrored",
				["text"] = {
					"If a {C:attention}Mirror{} is present,",
					"{C:attention}retrigger{} this card,",
					"otherwise it {C:red}self-destructs{}",
					"at end of round",
				},
			},
			["partofyou_complements"] = {
				["name"] = "Complements",
				["text"] = {
					"{s:0.83}Ace <> King{C:white,s:0.83}ii{s:0.83} ",
					"{s:0.83}  2 <> Queen",
					"{s:0.83}  3 <> Jack ",
					"{s:0.83}  4 <> 10   ",
					"{s:0.83}  5 <> 9    ",
					"{s:0.83}  6 <> 8    ",
					"{s:0.83}  7 <> 7    ",
				},
			},
			["ccc_acts_as_mirror"] = {
				["name"] = "n2",
				["text"] = {
					"{C:inactive,s:0.9}(Acts as a {C:attention,s:0.9}Mirror{C:inactive,s:0.9})",
				},
			},
			["ccc_focused"] = {
				["name"] = "n3",
				["text"] = {
					"{C:inactive,s:0.9}(Focused by {C:attention,s:0.9}#1#{C:inactive,s:0.9})",
				},
			},
		},
		["Joker"] = {
			["j_ccc_collapsingbridge"] = {
				["name"] = "Collapsing Bridge",
				["text"] = {
					"If played hand contains a",
					"{C:attention}Straight{}: {X:mult,C:white} X#2# {} Mult, and all",
					"{C:attention}played{} cards have a {C:green}#1# in #3#{}",
					"chance of being {C:red}destroyed{}",
				},
			},
			["j_ccc_refundpolicy"] = {
				["name"] = "Refund Policy",
				["text"] = {
					"On skipping a {C:attention}Booster Pack{},",
					"gain a {C:money}#1#% {C:attention}refund",
					"{C:inactive,s:0.8}(Rounded down){}",
				},
			},
			["j_ccc_rainbowspinner"] = {
				["name"] = "Rainbow Spinner",
				["text"] = {
					"{C:money}Gold Seals{} act as",
					"{C:attention}every{} {C:money}s{C:red}e{C:tarot}a{C:planet}l",
				},
			},
			["j_ccc_granny"] = {
				["name"] = "Granny",
				["text"] = {
					"After {C:red}discarding{} cards,",
					"{C:attention}draw{} {C:attention}#1#{} additional card",
					"for each card discarded",
				},
			},
			["j_ccc_cassette_block_pink"] = {
				["name"] = "Cassette Block",
				["text"] = {
					"Gains {C:mult}+#4#{} Mult for each",
					"{C:attention}unused{} {C:mult}discard{} at end of round",
					"{C:chips}Swaps{} at start of round",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}",
				},
			},
			["j_ccc_feather"] = {
				["name"] = "Feather",
				["text"] = {
					"Gains {X:mult,C:white} X#1# {} Mult when a",
					"card is {C:attention}drawn{} from deck,",
					"{C:red}resets{} at end of round",
					"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult){}",
				},
			},
			["j_ccc_badeline"] = {
				["name"] = "Badeline",
				["text"] = {
					"{C:attention}Sustain{} all {C:dark_edition}Mirrored{} and/or",
					"{C:attention}Glass{} cards, they each give",
					"{X:mult,C:white} X#1# {} Mult when scored",
				},
			},
			["j_ccc_wingedstrawberry"] = {
				["name"] = "Winged Strawberry",
				["text"] = {
					"Earn {C:money}$#2#{} if {C:attention}poker hand{} does",
					"not contain a {C:attention}#1#{},",
					"{s:0.8}poker hand changes at end of round",
				},
			},
			["j_ccc_zipper"] = {
				["name"] = "Zipper",
				["text"] = {
					"Gains {C:chips}+#2#{} Chips for each",
					"{C:attention}Blind{} skipped this run",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
				},
			},
			["j_ccc_mechanicalheart"] = {
				["name"] = "Mechanical Heart",
				["text"] = {
					"If played hand is a",
					"single {C:attention}Ace{} of {C:clubs}Clubs{}, turn",
					"{C:attention}all{} {C:clubs}Clubs{} held in hand into",
					"{C:attention}Steel Cards{} with {X:mult,C:white}X2{} Mult",
					"{C:inactive,s:0.87}(Unaffected by retriggers){}",
				},
			},
			["j_ccc_eventhorizon"] = {
				["name"] = "Event Horizon",
				["text"] = {
					"After using {C:attention}#2#{} {C:planet}Planet{} cards,",
					"the next {C:planet}Planet{} card used",
					"acts as a {C:legendary,E:1,S:1.1}Black Hole{}",
					"{C:inactive}(Currently {C:attention}#1#{C:inactive}/{C:attention}#2#{C:inactive})",
				},
			},
			["j_ccc_books"] = {
				["name"] = "Huge Mess: Books",
				["text"] = {
					"When played hand contains a",
					"{C:attention}Straight{}, gains {X:mult,C:white} X#2# {} Mult for",
					"each additional card held in hand",
					"that extends the played {C:attention}Straight{}",
					"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult){}",
				},
			},
			["j_ccc_moonberry"] = {
				["name"] = "Moon Berry",
				["text"] = {
					"If round ends without playing",
					"your most played {C:attention}poker hand{},",
					"upgrade its level {C:attention}#2#{} times",
					"{C:inactive,s:0.8}(Currently: {C:attention,s:0.8}#1#{C:inactive,s:0.8})",
				},
			},
			["j_ccc_thecrowd"] = {
				["name"] = "The Crowd",
				["text"] = {
					"If played hand contains a",
					"{C:attention}Five of a Kind{}, {C:attention}scoring{} cards",
					"give {C:money}$#2#{}. Afterwards, create the",
					"played poker hand's {C:planet}Planet{} card",
					"{C:inactive}(Must have room){}",
				},
			},
			["j_ccc_jump"] = {
				["name"] = "Jump",
				["text"] = {
					"{C:chips}+#1#{} Chips",
				},
			},
			["j_ccc_cloud"] = {
				["name"] = "Cloud",
				["text"] = {
					"Gains {C:chips}+#1#{} Chips",
					"{C:attention}after{} each hand",
					"played this round",
					"{C:inactive}(Currently {C:blue}+#2#{C:inactive} Chips)",
				},
			},
			["j_ccc_dash"] = {
				["name"] = "Dash",
				["text"] = {
					"{X:mult,C:white} X#1#{} Mult",
				},
			},
			["j_ccc_bunnyhop"] = {
				["name"] = "Bunny Hop",
				["text"] = {
					"Permanently give {C:chips}+#1#{} Chip",
					"to {C:attention}all{} cards held in hand",
					"on discarding a {C:attention}card{}",
				},
			},
			["j_ccc_heavyheart"] = {
				["name"] = "Heavy Heart",
				["text"] = {
					"If played hand is a",
					"single {C:attention}Ace{} of {C:diamonds}Diamonds{},",
					"earn {C:money}$#1#{} for each",
					"card held in hand",
					"{C:inactive,s:0.87}(Unaffected by retriggers){}",
				},
			},
			["j_ccc_quietheart"] = {
				["name"] = "Quiet Heart",
				["text"] = {
					"If played hand is a",
					"single {C:attention}Ace{} of {C:spades}Spades{},",
					"give permanent {C:chips}+#1#{} Chips",
					"to {C:attention}all{} cards held in hand",
					"{C:inactive,s:0.87}(Unaffected by retriggers){}",
				},
			},
			["j_ccc_cornerjump"] = {
				["name"] = "Cornerjump",
				["text"] = {
					"{C:chips}+#1#{} Chips if played hand",
					"contains an {C:attention}Ace{}, and",
					"either a {C:attention}King{} or a {C:attention}2{}",
				},
			},
			["j_ccc_tothesummit"] = {
				["name"] = "To The Summit",
				["text"] = {
					"Gains {X:mult,C:white} X#3# {} Mult for each",
					"{C:attention}consecutive Blind{} selected",
					"with more {C:money}money{} than",
					"the {C:attention}previous Blind{}",
					"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
					"{C:inactive}(Previous: {C:money}$#2#{C:inactive})",
				},
			},
			["j_ccc_iceball"] = {
				["name"] = "Iceball",
				["text"] = {
					"If your {C:attention}score display{} didn't",
					"catch {C:attention}fire{} during the",
					"{C:attention}previous{} round, {C:white,X:red}X3{} Mult",
				},
			},
			["j_ccc_chests"] = {
				["name"] = "Huge Mess: Chests",
				["text"] = {
					"When played hand contains a",
					"{C:attention}Three of a Kind{}, gains {C:mult}+#2#{} Mult",
					"for each possible {C:attention}Pair{} of a",
					"{C:attention}different{} rank held in hand",
					"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
				},
			},
			["j_ccc_goldenstrawberry"] = {
				["name"] = "Golden Strawberry",
				["text"] = {
					"Earn {C:money}$#1#{} at end of",
					"{C:attention}Boss Blind{}",
				},
			},
			["j_ccc_introcar"] = {
				["name"] = "Intro Car",
				["text"] = {
					"Before each {C:attention}5{} or {C:attention}8{} is",
					"scored, {C:attention}swap{} current",
					"{C:chips}Chips{} and {C:mult}Mult{}",
				},
			},
			["j_ccc_bumper"] = {
				["name"] = "Bumper",
				["text"] = {
					"If {C:mult}discards{} {C:attention}>{} {C:chips}hands{}, {C:mult}+#1#{} Mult",
					"If {C:chips}hands{} {C:attention}>{} {C:mult}discards{}, {C:chips}+#2#{} Chips",
					"If both are {C:attention}equal{}, does {C:inactive}nothing{}",
				},
			},
			["j_ccc_freeze"] = {
				["name"] = "Freeze",
				["text"] = {
					"Cards held in hand",
					"gain {C:chips}+#1#{} Chips",
					"until end of round",
				},
			},
			["j_ccc_coyotejump"] = {
				["name"] = "Coyote Jump",
				["text"] = {
					"If cards held in hand",
					"do not form a {C:attention}Pair{},",
					"{C:attention}Straight{}, or {C:attention}Flush{},",
					"gain {C:red}+#1#{} discard",
				},
			},
			["j_ccc_bird"] = {
				["name"] = "Bird",
				["text"] = {
					"Whenever a {C:planet}Planet{} card",
					"is used, {C:attention}draw{} {C:attention}#1#{} cards",
				},
			},
			["j_ccc_cassetteblock"] = {
				["name"] = "Cassette Block",
				["text"] = {
					"Gains {C:chips}+#3#{} Chips for each",
					"{C:attention}unused{} {C:chips}hand{} at end of round",
					"{C:mult}Swaps{} at start of round",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}",
				},
			},
			["j_ccc_bubsdrop"] = {
				["name"] = "Bubsdrop",
				["text"] = {
					"On defeat of {C:attention}Boss Blind{},",
					"{C:red}-$#2#{} and {C:attention}-#1#{} Ante, then",
					"{C:red}disable{} this card",
				},
			},
			["j_ccc_greenbooster"] = {
				["name"] = "Green Booster",
				["text"] = {
					"Adds {C:attention}#1#{} extra option",
					"to all {C:attention}Booster Packs{}",
				},
			},
			["j_ccc_smotsgaming"] = {
				["name"] = "smots gaming",
				["text"] = {
					"{C:dark_edition}+1{} Joker Slot",
					"{C:inactive}smots gaming",
				},
			},
			["j_ccc_grab"] = {
				["name"] = "Grab",
				["text"] = {
					"{C:mult}+#1#{} Mult if there is",
					"a {C:attention}Joker{} to the right",
				},
			},
			["j_ccc_brittlecloud"] = {
				["name"] = "Brittle Cloud",
				["text"] = {
					"{C:chips}+#1#{} Chips in",
					"{C:attention}first{} hand of round",
				},
			},
			["j_ccc_waterfall"] = {
				["name"] = "Waterfall",
				["text"] = {
					"If played hand contains a",
					"{C:attention}Flush{}, convert a random",
					"card {C:attention}held{} in hand to",
					"the same {C:attention}suit{}",
				},
			},
			["j_ccc_towels"] = {
				["name"] = "Huge Mess: Towels",
				["text"] = {
					"When played hand contains a",
					"{C:attention}Flush{}, gains {C:chips}+#2#{} Chips for",
					"each card held in hand that",
					"shares the same {C:attention}suit{}",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
				},
			},
			["j_ccc_strongwinds"] = {
				["name"] = "Strong Winds",
				["text"] = {
					"{X:mult,C:white} X#1# {} Mult",
					"The highest-{C:attention}ranked{} scoring",
					"card is {C:red}destroyed{}",
				},
			},
			["j_ccc_theocrystal"] = {
				["name"] = "Theo Crystal",
				["text"] = {
					"Forces 1 card to",
					"{C:attention}always{} be selected",
					"{C:green}#1#{} to {C:green,E:1}denominators{}",
					"on defeat of {C:attention}Boss Blind",
					"{C:inactive}(ex: {C:green}2 in 7{C:inactive} -> {C:green}2 in #3#{C:inactive})",
					"{C:inactive}(Currently {C:green}#2#{C:inactive})",
				},
			},
			["j_ccc_checkpoint"] = {
				["name"] = "Checkpoint",
				["text"] = {
					"Gains {X:mult,C:white} X#2#{} Mult if",
					"{C:attention}Boss Blind{} is defeated",
					"without {C:red}discarding{}",
					"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
				},
			},
			["j_ccc_redspinner"] = {
				["name"] = "Red Spinner",
				["text"] = {
					"When a card with a {C:red}Red Seal{}",
					"is {C:attention}discarded{}, {C:green}#1# in #2#{} chance",
					"to add a {C:red}Red Seal{} to each",
					"{C:attention}adjacent{} card in discarded hand",
					"{C:inactive,s:0.87}(Unaffected by retriggers){}",
				},
			},
			["j_ccc_templeeyes"] = {
				["name"] = "Temple Eyes",
				["text"] = {
					"If {C:attention}Blind{} is selected with",
					"{C:money}$#1#{} or less, create a",
					"{C:tarot}Hanged Man{}",
					"{C:inactive}(Must have room)",
				},
			},
			["j_ccc_coreswitch"] = {
				["name"] = "Core Switch",
				["text"] = {
					"Swap {C:blue}hands{} and {C:red}discards{}",
					"on blind select",
					"{C:red}+#1#{} discard after swap",
				},
			},
			["j_ccc_wingedgoldenstrawberry"] = {
				["name"] = "Winged Golden Strawberry",
				["text"] = {
					"Earn {C:money}$#2#{} at end of {C:attention}Boss Blind{} if",
					"beaten without playing a hand",
					"that contains a {C:attention}#1#{},",
					"{s:0.8}poker hand changes at end of round",
				},
			},
			["j_ccc_partofyou"] = {
				["name"] = "Part Of You",
				["text"] = {
					"If {C:attention}first hand{} of round",
					"contains exactly {C:attention}2{} cards,",
					"convert their {C:attention}ranks{} into",
					"their {C:dark_edition}Mirrored{} {C:attention}complements{}",
				},
			},
			["j_ccc_ominousmirror"] = {
				["name"] = "Ominous Mirror",
				["text"] = {
					"{C:green}#1# in #2#{} chance to add a",
					"permanent, {C:dark_edition}Mirrored{} copy of",
					"each scored card to your hand,",
					"{C:green}#3# in #4#{} chance to {C:inactive}break{}",
					"at end of round, becoming",
					"a {C:attention}Broken Mirror{}",
				},
			},
			["j_ccc_seeker"] = {
				["name"] = "Seeker",
				["text"] = {
					"If card is drawn {C:attention}face up{} and",
					"is not most owned {C:attention}rank{} ({C:attention}#1#{})",
					"or {C:attention}suit{} ({V:1}#2#{}), reshuffle",
					"it into {C:attention}deck{} and {C:attention}draw another",
				},
			},
			["j_ccc_broken_mirror"] = {
				["name"] = "Broken Mirror",
				["text"] = {
					"{C:inactive}Does nothing.",
				},
			},
			["j_ccc_strawberry"] = {
				["name"] = "Strawberry",
				["text"] = {
					"Earn {C:money}$#1#{} at end of",
					"round, reduces by {C:money}$#2#{}",
					"upon cashing out",
				},
			},
			["j_ccc_madeline"] = {
				["name"] = "Madeline",
				["text"] = {
					"{C:attention}Prevents{} reduction and",
					"resets of Joker {C:attention}values{}",
					"through owned abilities",
				},
			},
			["j_ccc_redbooster"] = {
				["name"] = "Red Booster",
				["text"] = {
					"Allows you to {C:attention}pick{}",
					"{C:attention}#1#{} extra card from",
					"all {C:attention}Booster Packs{}",
				},
			},
			["j_ccc_1up"] = {
				["name"] = "1UP",
				["text"] = {
					"Earn {C:money}$#1#{} at end of the round.",
					"This Joker increases by {C:money}$#2#{} when",
					"any {C:attention}Strawberry{} is sold, then",
					"reduces its increase by {C:money}$#3#{}",
					"{C:inactive}(Minimum of {C:money}$1{C:inactive})",
				},
			},
			["j_ccc_templerock"] = {
				["name"] = "Temple Rock",
				["text"] = {
					"Each {C:attention}Stone Card{} held",
					"in hand gives {C:chips}+#1#{} chips",
				},
			},
			["j_ccc_bluespinner"] = {
				["name"] = "Blue Spinner",
				["text"] = {
					"When a card with a {C:planet}Blue Seal{}",
					"is scored, {C:green}#1# in #2#{} chance",
					"to add a {C:planet}Blue Seal{} to each",
					"{C:attention}adjacent{} card in scored hand",
					"{C:inactive,s:0.87}(Unaffected by retriggers){}",
				},
			},
			["j_ccc_moveblock"] = {
				["name"] = "Move Block",
				["text"] = {
					"{C:mult}+#1#{} Mult per discard,",
					"{C:attention}resets{} if played hand",
					"contains a {C:attention}Three of a Kind",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
			},
			["j_ccc_purplespinner"] = {
				["name"] = "Purple Spinner",
				["text"] = {
					"When a card with a {C:tarot}Purple Seal{}",
					"is {C:attention}held{} in hand at end of round,",
					"{C:green}#1# in #2#{} chance to add a {C:tarot}Purple Seal{}",
					"to each {C:attention}adjacent{} card in hand",
					"{C:inactive,s:0.87}(Unaffected by retriggers){}",
				},
			},
			["j_ccc_lettinggo"] = {
				["name"] = "Letting Go",
				["text"] = {
					"When a card is destroyed,",
					"{C:green}#1# in #3#{} chance to create",
					"a {C:tarot}Death{}",
					"{C:inactive}(Must have room)",
					"Gains {X:mult,C:white} X#4# {} Mult for each",
					"{C:tarot}Death{} used",
					"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
				},
			},
			["j_ccc_secretshrine"] = {
				["name"] = "Secret Shrine",
				["text"] = {
					"Gives {C:mult}+#2#{} Mult for",
					"each {C:attention}7{} in {C:attention}full deck{}",
					"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}",
				},
			},
			["j_ccc_strawberrypie"] = {
				["name"] = "Strawberry Pie",
				["text"] = {
					"Grants a large bonus",
					"based on current {C:money}money{}:",
					"  {C:white}ii{}{C:money}$30{}-{C:money}$79{}: {C:chips}+#1#{} Chips",
					"{C:money}$80{}-{C:money}$174{}: {C:mult}+#2#{} Mult",
					"   {C:money}$175+{}: {X:mult,C:white} X#3# {} Mult{C:white}i{}",
				},
			},
			["j_ccc_climbinggear"] = {
				["name"] = "Climbing Gear",
				["text"] = {
					"{C:red}+#1#{} discards",
					"Played and discarded cards",
					"are reshuffled into deck",
				},
			},
			["j_ccc_pointlessmachines"] = {
				["name"] = "Pointless Machines",
				["text"] = {
					"Bad signal?",
				},
			},
			["j_ccc_crumblejoker"] = {
				["name"] = "Crumble Joker",
				["text"] = {
					"Played {C:attention}Stone Cards",
					"each give {X:mult,C:white} X#1# {} Mult",
					"and are {C:red}destroyed{}",
				},
			},
			["j_ccc_jokerppt"] = {
				["name"] = "joker.ppt",
				["text"] = {
					"If {C:attention}#1#{} is played {C:attention}during",
					"the round, create its {C:planet}Planet{}",
					"card at the end of round,",
					"{s:0.8}poker hand changes at end of round",
				},
			},
			["j_ccc_fireball"] = {
				["name"] = "Fireball",
				["text"] = {
					"If your {C:attention}score display{} catches {C:attention}fire{}",
					"during the round, next shop will",
					"have an {C:attention}extra Mega{} booster pack",
				},
			},
			["j_ccc_switchgate"] = {
				["name"] = "Switch Gate",
				["text"] = {
					"Gains {C:chips}+#8#{} Chips if {C:attention}any{} of the",
					"following cards are scored:",
					"{C:attention}#2#{} of {V:1}#3#{}",
					"{C:attention}#4#{} of {V:2}#5#{}",
					"{C:attention}#6#{} of {V:3}#7#{}",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}",
					"{s:0.8}Cards change every round",
				},
			},
			["j_ccc_berryseeds"] = {
				["name"] = "Berry Seeds",
				["text"] = {
					"After scoring {C:attention}#2#{} {V:1}#3#{} cards,",
					"sell this card to {C:attention}create{}",
					"a random {C:attention}Strawberry{}",
					"{C:inactive}(Currently {C:attention}#1#{C:inactive}/#2#)",
				},
			},
			["j_ccc_hardlist"] = {
				["name"] = "5-Star Hardlist",
				["text"] = {
					"{C:mult}+#1#{} Mult",
					"{C:mult}-#2#{} Mult on purchase of a",
					"{C:attention}Joker{} or {C:attention}Buffoon Pack{}",
				},
			},
			["j_ccc_hyperdash"] = {
				["name"] = "Hyperdash",
				["text"] = {
					"After {C:attention}discarding{} a hand that",
					"contains {C:attention}Two Pair{}, {X:mult,C:white} X#1# {} Mult",
					"for the {C:attention}next{} played hand",
				},
			},
			["j_ccc_lapidary"] = {
				["name"] = "Lapidary",
				["text"] = {
					"Jokers with a",
					"{C:attention}unique{} rarity each",
					"give {X:mult,C:white}X#1#{} Mult",
				},
			},
			["j_ccc_pico8joker"] = {
				["name"] = "PICO-8 Joker",
				["text"] = {
					"Retrigger each",
					"played {C:attention}Ace{}, {C:attention}8{}, or {C:attention}6{}",
				},
			},
			["j_ccc_miniheart"] = {
				["name"] = "Mini Heart",
				["text"] = {
					"{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{}",
					"edition to scored cards",
					"{C:attention}before scoring{}",
				},
			},
			["j_ccc_thelastjoker"] = {
				["name"] = "One Last Thing",
				["text"] = {
					"???",
				},
			},
			["j_ccc_kevin"] = {
				["name"] = "Kevin",
				["text"] = {
					"Scoring {C:attention}face cards{} act",
					"as a copy of the",
					"{C:attention}rightmost{} played card",
				},
			},
			["j_ccc_slightmiscalculation"] = {
				["name"] = "Slight Miscalculation",
				["text"] = {
					"{C:mult}+#1#{} Mult if {C:attention}scoring hand{} starts",
					"and ends with the {C:attention}same{} rank",
					"{C:inactive}(ex: 3, 7, 7, 3)",
				},
			},
			["j_ccc_crystalheart"] = {
				["name"] = "Crystal Heart",
				["text"] = {
					"If played hand is a",
					"single {C:attention}Ace{} of {C:hearts}Hearts{},",
					"apply a random {C:dark_edition}Edition{}",
					"to {C:attention}#1#{} cards held in hand",
					"{C:inactive,s:0.87}(Unaffected by retriggers){}",
				},
			},
		},
		["Voucher"] = {
			["v_ccc_gondola"] = {
				["name"] = "Fast Track",
				["text"] = {
					"{C:attention}+1{} Ante",
					"Blinds require {C:red}30%{} less chips",
				},
			},
			["v_ccc_feather"] = {
				["name"] = "Mindfulness",
				["text"] = {
					"Blinds require {C:red}30%{} less chips",
				},
			},
		},
		["Edition"] = {
			["e_ccc_mirrored"] = {
				["label"] = "Mirrored",
				["name"] = "Mirrored",
				["text"] = {
					"If a {C:attention}Mirror{} is present,",
					"{C:attention}retrigger{} this card,",
					"otherwise it {C:red}self-destructs{}",
					"at end of round",
				},
			},
		},
		["Spectral"] = {
			["c_ccc_crystallic"] = {
				["name"] = "Crystallic",
				["text"] = {
					"Destroys {C:attention}#1#{} random cards in",
					"hand, then adds {C:dark_edition}Mirrored{} to",
					"{C:attention}all{} other cards in hand",
				},
			},
		},
	},
}
