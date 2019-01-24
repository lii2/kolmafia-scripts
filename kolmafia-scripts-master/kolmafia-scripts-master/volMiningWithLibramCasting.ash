/* BUGS & FEATURES
will not check HP >0 or Hot resist >=15, or even if you can access the mine
mines the first 2 rows of sparklies
only looks for 1 chunk of gold per mine. 
	DEADNED (#1909053)
equips an outfit called "volcano mining"
auto casts librams
	Bloody Knuckles (#1761123)
*/
int minetime=0;
void mineReset(){
string page=visit_url("mining.php?mine=6");
	matcher m = create_matcher("Find New Cavern",page); 
if (m.find()){
	print("restart!","red");
	visit_url("mining.php?reset=1&mine=6&pwd="+my_hash(),true);
	visit_url("mining.php?mine=6");
	}
else{
	visit_url("mining.php?mine=6&which=52&pwd="+my_hash());
	minetime+=1;
	}
}
void volMining( int clementine){
outfit("Volcano Mining");
int msq=52;
while (minetime < clementine ){
	int i=0;
	int [int] aMine;
	string page=visit_url("mining.php?mine=6");
		matcher m = create_matcher("mine=6&which=(\\d+)&pwd=[^<]*<[^<]*walls",page); 
	while (m.find()){
		msq=m.group(1).to_int();
		if (msq>40){
			i+=1;
			aMine[i]=msq;
			}
		}
	if (i==0)
		mineReset(); 
	else if(get_property("mineLayout6").contains_text("gold")) 
		mineReset(); 
	else{
		visit_url("mining.php?mine=6&which="+aMine[i]+"&pwd="+my_hash());
		minetime+=1;
		}
		
		if ( my_mp() > mp_cost($skill[Summon Love Song]) + 30 )
			 use_skill(1, $skill[Summon Love Song]);
	}
}

void main(int squares2mine){
int startGold=item_amount($item[1,970 carat gold]);
volMining(squares2mine); //mines boring squares, dude
int endGold=item_amount($item[1,970 carat gold])-startGold;
print(endGold+" golds obtained","blue");
}

