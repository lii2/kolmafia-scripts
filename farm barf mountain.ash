int getRemainingAdvTillSemiRare(){
	return substring(get_property("relayCounters"), 0, index_of(get_property("relayCounters"),":")).to_int() - my_turncount();
}

boolean haveSemirareCounter(){
	return substring(get_property("relayCounters"), index_of(get_property("relayCounters"),":") + 1, last_index_of(get_property("relayCounters"),":")) == "Fortune Cookie";
}

void cycleSemiRare(){
	if(fullness_limit()-my_fullness() > 0 && my_fullness()!= 0){
		eat(1,$item[tasty tart]);
	}

	if(!haveSemirareCounter()){
		if(inebriety_limit()-my_inebriety() > 0 ){
			cli_execute("drink lucky lindy");
		}else{
			print("You're way too drunk to use this script");
		}
	}

	print("Last semi-rare location: " + get_property("semirareLocation"), "Blue");
	print("Next semi-rare in: " + getRemainingAdvTillSemiRare() + " adventures", "Blue");
	adventure( getRemainingAdvTillSemiRare(), $location[Barf Mountain] );
	if(get_counters( "Fortune Cookie", 0, 0 ) == "Fortune Cookie"){
		if( get_property("semirareLocation") == "The Castle in the Clouds in the Sky (Top Floor)"){
			while (!adventure(1,$location[The Haunted Pantry])) {
				print("Skipping counter warning and adventuring once.");
			}
		}else{
			while (!adventure(1,$location[The Castle in the Clouds in the Sky (Top Floor)])) {
				print("Skipping counter warning and adventuring once.");
			}
		}
	}
}

void main(){
	if(getRemainingAdvTillSemiRare() > 90){
		int useAmount = min(item_amount($item[Gene Tonic: Humanoid]), 3);
		use(useAmount, $item[Gene Tonic: Humanoid]);
		cli_execute("concert Winklered");
	}

// Do fortune teller zatara buff and demon buffs	
	//if(getRemainingAdvTillSemiRare() > 100){
		//cli_execute("try fortune buff meat");
	//}
	
	while(item_amount($item[frost flower]) > 0
		&& getRemainingAdvTillSemiRare() - have_effect($effect[Frosty]) > 50
		&& my_adventures() - have_effect($effect[Frosty]) > 50){
			use(1, $item[frost flower]);
		}
	
	outfit("barf mountain");
	equip($slot[familiar], $item[Snow Suit]);
	cycleSemiRare();
	use(item_amount($item[bag of park garbage]), $item[bag of park garbage]);
	use(item_amount($item[Gathered Meat-Clip]), $item[Gathered Meat-Clip]);
	autosell(item_amount($item[cheap sunglasses])-1, $item[cheap sunglasses]);
	autosell(item_amount($item[garbage juice slurpee]), $item[garbage juice slurpee]);
	autosell(item_amount($item[bag of gross foreign snacks]), $item[bag of gross foreign snacks]);
	autosell(item_amount($item[filthy child leash]), $item[filthy child leash]);
	autosell(item_amount($item[expensive camera]), $item[expensive camera]);
}