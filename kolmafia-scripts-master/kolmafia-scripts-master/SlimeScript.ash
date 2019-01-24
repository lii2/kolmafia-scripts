/*
Alternates between high and low ML outfit to adventure in the slime tube
	Bloody Knuckles (#1761123)
*/

void main (int TurnsToSlime){
	cli_execute("set choiceAdventure337 = 3");
	int SlimeTurns = 0;
	int ChamoisUsed = 0;

	
	while(SlimeTurns<TurnsToSlime)
	{

		
	if ( have_effect( $effect[Coated in Slime] ) < 6 )
		{
		visit_url( "clan_slimetube.php?action=chamois" );
		print ("Slime cleaned with Chamois", "green");
		ChamoisUsed = ChamoisUsed + 1;
		}

	if ( have_effect( $effect[Coated in Slime] ) == 0 ){
			outfit("no slime");
			adventure(1,$location[The Slime Tube]);
			outfit("slime");
		}
		else{
			adventure(1,$location[The Slime Tube]);
		}
		
	SlimeTurns = SlimeTurns + 1;
	
	}
	print( ChamoisUsed + "Chamois Used", "green");
}
