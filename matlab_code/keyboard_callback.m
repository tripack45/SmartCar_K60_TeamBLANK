
function keyboard_callback(ObjH, EventData)
global com;
Key = get(ObjH, 'CurrentCharacter');
switch Key
    case char(105)
        fwrite(com,[172,209,0,0,125]);
    case char(107)
        fwrite(com,[172,210,0,0,126]);
    case char(106)
        fwrite(com,[172,211,0,0,127]);
    case char(108)
        fwrite(com,[172,212,0,0,128]);
    case char(113)
        fwrite(com,[172,255,0,0,171]);
    otherwise
        disp(double(Key))
end