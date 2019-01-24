/*
Bloody Knuckles (#1761123)
1) Automatically eats the cheapest lasagna with field gar and milk
	a) assumes you have tome of clip art 
	b) If it's monday, it'll do nothing
2) Casts booze twice and drinks the cheapest perfect booze
	a) assumes you have the Ode to Booze skill
	b) only buys the number of booze u don't have
	c) Only drinks to 18/12 drunkeness (in case you want to drink a lucky lindy) //still always buys 
3) Buys and chews 3 golden powders 
	a) tries to make carrot juice and chew that.
*/

/*************Functions*******************/
boolean IsItMonday(){
	//is it?
	return(numeric_modifier($item[tuesday's ruby], "muscle percent") == 5.0);
}

//only buys the number what I don't have
void BuyWhatINeed( int qty, item it ){
	int need = qty - item_amount(it);
	buy(need, it);
}

void CreateWhatINeed( int qty, item it ){
	int need = qty - item_amount(it);
	create(need, it);
}

/*************Script starts here *************/
void main (){
	if(my_inebriety()==0)
		{	
			
			int Item_Index = 8737;
			int Item_Price = 9999;
			item Best_Drink = to_item(Item_Index);
			while ( Item_Index < 8743 )
			{
			if( Item_Price > mall_price(Item_Index.to_item()) )
				Best_Drink = Item_Index.to_item();
			Item_Index = Item_Index+1;
			}
			
			if( have_effect($effect[Ode to Booze]) < 20){
				if( my_mp() < 100 ){
					restore_mp(100);
				}			
				use_skill(2, $skill[The Ode to Booze]);
			}
		
			if(have_skill($skill[Liver of Steel])){
				BuyWhatINeed(6, Best_Drink);
				drink(6, Best_Drink);
			}else{
				BuyWhatINeed(4, Best_Drink);
				drink(4, Best_Drink);
			}
			

		}else{print("You already drank something!", "Red");}
		
	if(my_fullness()==0)
		{	
			if( have_effect($effect[Got Milk]) < 15){			
				BuyWhatINeed(1, $item[milk of magnesium]);
				use(1, $item[milk of magnesium]);
			}
			
			if(IsItMonday()){	
				print("It's Monday!","Red");
			}else{
				CreateWhatINeed(1, $item[5257]); //potion of the field gar
				use(1, $item[5257]); //potion of the field gar
				
				item Best_Lasagna = $item[fishy fish lasagna];
				Int Item_Price = mall_price(Best_Lasagna);

				if (mall_price($item[gnat lasagna]) < Item_Price)
					Best_Lasagna = $item[gnat lasagna];
					
				if (mall_price($item[long pork lasagna]) < Item_Price)
					Best_Lasagna = $item[long pork lasagna];

				BuyWhatINeed(5,Best_Lasagna);
				eat(5, Best_Lasagna);
			}	

		}
		else{print("You already ate something!", "Red");}

	if(my_spleen_use()==0)
		{	
			BuyWhatINeed(1, $item[powdered gold]);
			chew(1, $item[powdered gold]);
			chew(2, $item[handful of Smithereens]);
			CreateWhatINeed(3, $item[carrot juice]);
			chew(3, $item[carrot juice]);
		}else{print("You already used a spleen item!", "Red");}
}
