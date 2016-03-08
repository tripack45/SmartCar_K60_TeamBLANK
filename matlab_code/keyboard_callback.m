function keyboard_callback(ObjH, EventData)
Key = get(ObjH, 'CurrentCharacter');
switch Key
case char(30)
  disp('up');
case char(31)
  disp('down');
otherwise
  disp(double(Key))
end