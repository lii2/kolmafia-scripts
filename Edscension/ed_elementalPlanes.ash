script "ed_elementalPlanes.ash"

boolean elementalPlanes_initializeSettings()
{
	string temp = "";

	if(!get_property("sleazeAirportAlways").to_boolean())
	{
		temp = visit_url("place.php?whichplace=airport_sleaze&intro=1");
		if(contains_text(temp, "you take a short, turbulence-free flight to Spring Break Beach."))
		{
			print("We have access to Spring Break Beach. Woo.", "green");
			set_property("sleazeAirportAlways", true);
		}
	}

	if(!get_property("spookyAirportAlways").to_boolean())
	{
		temp = visit_url("place.php?whichplace=airport_spooky&intro=1");
		if(contains_text(temp, "Your flight to Conspiracy Island is nasty, brutish and short."))
		{
			print("We have access to Conspiracy Island. Boo.", "green");
			set_property("spookyAirportAlways", true);
		}
	}

	if(!get_property("stenchAirportAlways").to_boolean())
	{
		temp = visit_url("place.php?whichplace=airport_stench&intro=1");
		if(contains_text(temp, "You get in line with the thousands of other passengers bound for Dinseylandfill."))
		{
			print("We have access to Dinseylandfill. Eww.", "green");
			set_property("stenchAirportAlways", true);
		}
	}
	return true;
}


boolean elementalPlanes_access(element ele)
{
#	return (get_property("_" + ele + "AirportToday").to_boolean() || get_property(ele + "AirportAlways").to_boolean());
	return get_property(ele + "AirportAlways").to_boolean();
}

boolean elementalPlanes_takeJob(element ele)
{
	if(!elementalPlanes_access(ele))
	{
		return false;
	}

	switch(ele)
	{
	case $element[spooky]:
		visit_url("place.php?whichplace=airport_spooky&action=airport2_radio");
		visit_url("choice.php?pwd&whichchoice=984&option=1", true);
		return true;
	case $element[stench]:
		string page = visit_url("place.php?whichplace=airport_stench&action=airport3_kiosk");
		int choice = 1;
		int at = index_of(page, "Available Assignments");
		if(at == -1)
		{
			return false;
		}

		int sustenance = index_of(page, "Guest Sustenance Assurance", at);
		boolean[string] jobs = $strings[Racism Reduction, Compulsory Fun, Waterway Debris Removal, Bear Removal, Electrical Maintenance, Track Maintenance, Sexism Reduction];

		if(sustenance != -1)
		{
			print("Trying to avoid Guest Sustenance Assurance Dinseylandfill job.", "blue");
			foreach job in jobs
			{
				int newAt = index_of(page, job, at);
				if(newAt != -1)
				{
					print("Found new job option: " + job, "blue");
					if(newAt < sustenance)
					{
						choice = 1;
					}
					else
					{
						choice = 2;
					}
				}
			}
		}

		visit_url("choice.php?pwd=&whichchoice=1066&option=" + choice,true);
		return true;
	}
	return false;
}

boolean dinseylandfill_garbageMoney()
{
	if(!elementalPlanes_access($element[stench]))
	{
		return false;
	}
	if(get_property("ed_dinseyGarbageMoney").to_int() == my_daycount())
	{
		return false;
	}
	if(!get_property("ed_getDinseyGarbageMoney").to_boolean())
	{
		return false;
	}
	if(item_amount($item[Bag of Park Garbage]) > 0)
	{
		set_property("ed_dinseyGarbageMoney", my_daycount());
		visit_url("place.php?whichplace=airport_stench&action=airport3_tunnels");
		visit_url("choice.php?pwd=&whichchoice=1067&option=6",true);
		visit_url("main.php");
		cli_execute("refresh inv");
		return true;
	}
	else
	{
		return false;
	}

	return false;
}