function save_events(save,n,mag)

    global ar;
    
    if save
        ar.pt.saveEvents = 1; 
    end
    if n ~= 0
        ar.pt.count = n;
    end
    ar.pt.mag = mag;
end