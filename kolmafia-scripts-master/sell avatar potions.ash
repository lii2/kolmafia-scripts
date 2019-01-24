boolean is_avatar_potion( item it )
{
    return it.effect_modifier( "Effect" ).string_modifier( "Avatar" ) != "";
}


void main()
{
  int[item] inventory = get_inventory() ;
  foreach it in inventory
  {
    if (is_avatar_potion(it))
    {
      autosell(inventory[it], it);
    }
  }
}
