class MyTheme(AnsiColorTheme):
    style_normal = Color.normal
    style_prompt = Color.red + Color.bold
    style_punct = Color.normal
    style_id = Color.red
    style_not_printable = Color.black + Color.bold
    style_layer_name = Color.yellow + Color.bold
    style_field_name = Color.cyan + Color.bold
    style_field_value = Color.purple + Color.bold
    style_emph_field_name = Color.cyan + Color.bold
    style_emph_field_value = Color.red + Color.bold
    style_packetlist_name = Color.black + Color.bold
    style_packetlist_proto = Color.yellow + Color.bold
    style_packetlist_value = Color.purple + Color.bold
    style_fail = Color.red + Color.bold
    style_success = Color.green + Color.bold
    style_even = Color.black + Color.bold
    style_odd = Color.grey + Color.bold
    style_opening = Color.yellow + Color.bold
    style_active = Color.grey + Color.bold
    style_closed = Color.black + Color.bold
    style_left = Color.cyan + Color.bold
    style_right = Color.red + Color.bold

conf.color_theme = MyTheme()
