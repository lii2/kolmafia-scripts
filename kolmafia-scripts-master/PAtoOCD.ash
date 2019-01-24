// PAtoOCD.ash
// by Zarqon
// adds PA's recommended course to OCD for all items not currently in your OCD database
// Like it?  Send batbits!

import <zlib.ash>
import <priceadvisor.ash>

int keepgear = 2;                // keep equipment
int keepother = 5;               // keep non-equipment
int keepvalue = 100000;          // keep all of anything worth more than this

record ocd_data {
   string act;
   int keep;
   string info;
}[item] ocdata;
if (!file_to_map("OCDdata_"+vars["BaleOCD_DataFile"]+".txt",ocdata) || count(ocdata) == 0) file_to_map("OCD_"+my_name()+"_data.txt",ocdata);

price_advice course;
foreach it in get_inventory() {
   if (ocdata contains it) continue;
   if (to_slot(it) != $slot[none]) ocdata[it].keep = keepgear;
    else ocdata[it].keep = keepother;
   course = best_advice(it,true);
   if (mall_price(it) >= keepvalue) ocdata[it].act = "KEEP";
    else switch (excise(course.action,""," ")) {
      case "smash": ocdata[it].act = "PULV"; break;
      case "use": ocdata[it].act = "USE";  break;
      case "autosell": ocdata[it].act = "AUTO"; break;
      case "mallsell": ocdata[it].act = "MALL"; break;
      case "untinker": ocdata[it].act = "UNTN"; break;
      case "make":
      case "acquire": if (contains_text(course.action,"make ")) {
            item tomake = to_item(excise(course.action,"make ",";"));
            if (tomake == $item[none]) { ocdata[it].act = "KEEP"; break; }
            int[item] ings = get_ingredients(tomake);
            if (count(ings) == 0 || !(ings contains it)) { ocdata[it].act = "KEEP"; break; }
            ocdata[it].act = "MAKE"; ocdata[it].info = to_string(tomake); break;
         }
      default: ocdata[it].act = "KEEP"; break;
   }
   print("Added "+it+" ("+item_amount(it)+"): "+ocdata[it].act+" "+ocdata[it].info+" (keep "+rnum(ocdata[it].keep)+")");
}
if (map_to_file(ocdata,"OCDdata_"+vars["BaleOCD_DataFile"]+".txt")) print("OCD map updated for "+my_name()+". Please check the above output to make sure nothing stupid was done.");