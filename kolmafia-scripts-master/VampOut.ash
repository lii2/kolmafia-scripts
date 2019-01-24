script "VampOut Daily Deed";
notify <Bale>;
string soft = "VampOut Daily Deed";	// This is the script's name
string thisver = "1.5";			// This is the script's version!
int thread = 10670;


string delete_deed(string deeds, string prop) {
	if(deeds.contains_text(prop))
		return replace_all(create_matcher( "\\$CUSTOM[^,]*"+prop+"[^,]*[,$]" , deeds), "");
	return deeds;
}

boolean book = false;

void insert_deeds() {
	boolean one_deed = false; // This is just something I've played around with, but not enabled.
	string dailyDeedsOptions = get_property("dailyDeedsOptions");
	
	if(one_deed && !dailyDeedsOptions.contains_text("_interviewAll")) {
		string deed = "$CUSTOM|Combo|Vamp Out|_interviewAll|"
			+ "$ITEM|Mistified (effect)|_interviewVlad|VampOut Damage Reduction 30|$ITEM|Bat Attitude (effect)|_interviewVlad|VampOut Spell Damage +100%|$ITEM|There Wolf (effect)|_interviewVlad|VampOut Weapon Damage +100%|"
			+ "$ITEM|Gain Muscle|_interviewIsabella|VampOut Muscle Stats|$ITEM|Gain Mysticality Stats|_interviewIsabella|VampOut Myst|$ITEM|Gain Moxie Stats|_interviewIsabella|VampOut Moxie|$ITEM|111 Meat & lose 1-2 hp|_interviewIsabella|VampOut Gain Meat|"
			+ "$ITEM|Prince (effect) and Sword|_interviewMasquerade|VampOut Sword of the Brouhaha (Muscle)|$ITEM|Prince (effect) and Sceptre|_interviewMasquerade|VampOut Sceptre of the Torremolinos (Myst)|"
			+ "$ITEM|Prince (effect) and Medallion|_interviewMasquerade|VampOut Medallion of the Ventrilo (Moxie)|$ITEM|Prince (effect) and Chalice|_interviewMasquerade|VampOut Chalice of the Malkovich (all stats)|"
			+ "$ITEM|Pride (effect) and Book|_interviewMasquerade|VampOut Book form of Adventure|$ITEM|your own black heart|_interviewMasquerade|VampOut your own black heart restores all HP/MP";
		
		dailyDeedsOptions = delete_deed(dailyDeedsOptions, "_interviewAll");
		set_property("dailyDeedsOptions", dailyDeedsOptions+","+deed);
		
	} else {
		string vlad = "$CUSTOM|Combo|Vamp at Vlad's|_interviewVlad|$ITEM|Mistified (effect)|false|VampOut Damage Reduction 30|$ITEM|Bat Attitude (effect)|false|VampOut Spell Damage +100%|$ITEM|There Wolf (effect)|false|VampOut Weapon Damage +100%";
		string isabella = "$CUSTOM|Combo|Vamp at Isabella's|_interviewIsabella|$ITEM|Gain Muscle Stats|false|VampOut Muscle|$ITEM|Gain Myst Stats|false|VampOut Mysticality|$ITEM|Gain Moxie Stats|false|VampOut Moxie|$ITEM|111 Meat & lose 1-2 hp|false|VampOut Gain Meat";
		string masquerade = "$CUSTOM|Combo|Vamp at Masquerade|_interviewMasquerade|$ITEM|Prince (effect) and Sword|false|VampOut Sword of the Brouhaha (Muscle)|$ITEM|Prince (effect) and Sceptre|false|VampOut Sceptre of the Torremolinos (Myst)|"
			+ "$ITEM|Prince (effect) and Medallion|false|VampOut Medallion of the Ventrilo (Moxie)|$ITEM|Prince (effect) and Chalice|false|VampOut Chalice of the Malkovich (all stats)|"
			+ "$ITEM|Pride (effect) and Book|false|VampOut Book form of Adventure|$ITEM|your own black heart|false|VampOut your own black heart restores all HP/MP";
		
		dailyDeedsOptions = delete_deed(dailyDeedsOptions, "_interviewVlad");
		dailyDeedsOptions = dailyDeedsOptions+","+vlad;
		
		dailyDeedsOptions = delete_deed(dailyDeedsOptions, "_interviewIsabella");
		dailyDeedsOptions = dailyDeedsOptions+","+isabella;
		
		dailyDeedsOptions = delete_deed(dailyDeedsOptions, "_interviewMasquerade");
		dailyDeedsOptions = dailyDeedsOptions+","+masquerade;

		set_property("dailyDeedsOptions", dailyDeedsOptions);
	}
	
	print("Daily Deeds for Vamping Out have been added!", "green");
}

// Error message
boolean print_error(string error) {
	print(error, "red");
	return false;
}

// Verify that the choice is good
boolean check_choice(int choice) {
	if(available_amount($item[plastic vampire fangs]) < 1) {
		if(can_interact() || available_amount($item[Interview With You (a Vampire)]) > 0) {
			book = true;
			print("You will be using \"Interview With You (a Vampire)\" since you don't have your own fangs", "olive");
		} else
			return print_error("You don't have any plastic vampire fangs.");
	}
	if(choice > 13 || choice < 1)
		return print_error("invalid option for Vamping Out");
	if(choice < 4) {
		if(get_property("_interviewVlad") == "true")
			return print_error("You've already Vamped Out with Vlad today.");
	} else if(choice < 8) {
		if(get_property("_interviewIsabella") == "true")
			return print_error("You've already Vamped Out with Isabella today.");
	} else if(get_property("_interviewMasquerade") == "true")
		return print_error("You've already Vamped Out at the Masquerade today.");
	return true;
}

void vamp_out(int choice) {
	// First let's make sure that some sort of Fubar didn't send us here.
	if(check_choice(choice)) {
		boolean locked = false;
		cli_execute("checkpoint");
		// Equip Fangs and otherwise adjust outfit behind executing choice.
		try {
			if(book)
				retrieve_item(1, $item[Interview With You (a Vampire)]);
			else if(equipped_amount($item[plastic vampire fangs]) < 1 && retrieve_item(1, $item[plastic vampire fangs]))
				equip($item[plastic vampire fangs]);
			// Removed SBIP or Staff of Homophones.
			if(equipped_amount($item[staph of homophones]) + equipped_amount($item[sword behind inappropriate prepositions]) > 0)
				equip($slot[weapon], $item[none]);
			// Vamp Out
			set_property("choiceAdventure546", choice); 
			// choice = DamRed-SpellDamage-WeapDamage (1-3), Muscle-Myst-Moxie (4-6), Meat (7), Sword-Scepter-Medallion-Chalice (8-11), Book (12), Black Heart (13)
			locked = true;
			if(book)
				use(1, $item[Interview With You (a Vampire)]);
			else
				visit_url("place.php?whichplace=town&action=town_vampout");
			cli_execute("choice-goal");
			locked = false;
		} finally {
			// Restore Outfit, if not trapped in the choice adventure
			if(!locked)
				cli_execute("outfit checkpoint");
		}
	}
	#if(get_property("_interviewVlad").to_boolean() && get_property("_interviewIsabella").to_boolean() && get_property("_interviewMasquerade").to_boolean())
	#	set_property("_interviewAll", "true");
}

// Modified from zarqon's zlib
boolean check_version() {
	record {
	   string ver;
	   string vdate;
	} [string] zv;
	file_to_map("zversions.txt", zv);
	boolean sameornewer(string local, string server) {
		if(local == server) return true;
		string[int] loc = split_string(local,"\\.");
		string[int] ser = split_string(server,"\\.");
		for i from 0 to max(count(loc)-1, count(ser)-1) {
			if(i+1 > count(loc)) return false; if (i+1 > count(ser)) return true;
			if(loc[i].to_int() < ser[i].to_int()) return false;
			if(loc[i].to_int() > ser[i].to_int()) return true;
		}
		return true;
	}
	// Execute the following only once per day.
	if(zv[soft].vdate != today_to_string()) {
		// 1. Check program version info
		print("Checking for updates (running Bale's "+soft+" script ver. "+thisver+")...");
		matcher find_ver = create_matcher("<b>"+soft+" (.+?)</b>",
			visit_url("http://kolmafia.us/showthread.php?t="+thread));
		zv[soft].vdate = today_to_string();
		if (!find_ver.find()) {
			print("Unable to load current version info.");
			map_to_file(zv, "zversions.txt");
			return true;
		}
		zv[soft].ver = find_ver.group(1);
		// 2. Save current version information.
		map_to_file(zv,"zversions.txt");
		if(sameornewer(thisver,zv[soft].ver))
			return true;
		print_html("<div style='font-size:140%; font-weight:bold; color:red; font-family:Arial,Helvetica,sans-serif'>New Version of "+soft+" Available: "+zv[soft].ver+"</div><br />"+
		  "<div style='font-family:Arial,Helvetica,sans-serif'><a href='http://kolmafia.us/showthread.php?t="+thread+"' target='_blank'><u>Upgrade from "+thisver+" to "+zv[soft].ver+" here!</u></a></div><br />");
	} else if(sameornewer(thisver,zv[soft].ver))
		return true; 
	return false;
}

int choice_toint(string choice) {
	switch(to_lower_case(choice)) {
	case "":
		return 0;
	case "mainstat":
	case "main":
		return my_primestat().to_string().choice_toint();
	case "damage reduction 30":
	case "dr":
		return 1;
	case "spell damage +100%":
	case "spell":
		return 2;
	case "weapon damage +100%":
	case "weapon":
	case "weap":
		return 3;
	case "muscle":
	case "mus":
		return 4;
	case "mysticality":
	case "myst":
	case "mys":
		return 5;
	case "moxie":
	case "mox":
		return 6;
	case "gain meat":
	case "meat":
		return 7;
	case "sword of the brouhaha (muscle)":
	case "sword":
		return 8;
	case "sceptre of the torremolinos (myst)":
	case "sceptre":
		return 9;
	case "medallion of the ventrilo (moxie)":
	case "medallion":
		return 10;
	case "chalice of the malkovich (all stats)":
	case "chalice":
		return 11;
	case "book form of adventure":
	case "book":
		return 12;
	case "your own black heart restores all hp/mp":
	case "black heart":
	case "heart":
		return 13;
	}
	if(is_integer(choice)) {
		int i = choice.to_int();
		if(i >= 0 && i < 14) return i;
	}
	print("I don't know what kind of vamping \"" + choice + "\" might be, so I'll verify Vamping in your Daily Deeds.", "#dd0000");
	return 0;
}

// If vamp_choice is 0, it will create a daily deed.
void main (string choice) {
	check_version();
	int vchoice = choice_toint(choice);
	if(vchoice == 0)
		insert_deeds();
	else
		vamp_out(vchoice);
}
