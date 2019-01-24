
boolean haveSemirareCounter(){
	return substring(get_property("relayCounters"), index_of(get_property("relayCounters"),":")+1, last_index_of(get_property("relayCounters"),":")) == "Fortune Cookie";
}

void main(){
	print(haveSemirareCounter());
}