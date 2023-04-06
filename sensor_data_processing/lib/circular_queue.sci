    //Circular Queue
    TAILLE = 11;
    global CQ;
    CQ = zeros(TAILLE);
    global rear;
    global front;
    rear = -1;
    front =-1;
    
    //full ?
    function rep = CQfull()
        global rear;
        global front;
        if ((front == rear + 1) || (front == 0 && rear == TAILLE - 1)) then
            rep= 1;
            end
        rep = 0;
    endfunction
    
    //insert
    function inser(val)
        global rear;
        global front;
        global CQ;
        if(CQfull()) then
            disp("Queue overflow");
        else
            if(front== -1) then front =0; end
            disp(rear)
            rear=modulo(rear+1,TAILLE);
            CQ(rear+1)=val;
        end
        
    endfunction
    
    //delete
        function val = delet(val)
        global rear;
        global front;
        global CQ;
        if(front == -1 ) then //empty ?
            disp("Queue underflow");
        else
            val = CQ(front+1);
            if(front==rear) then
                front =-1;
                rear =-1;
            else
                front = modulo(front+1,TAILLE);
            end
        end
        
    endfunction
    
    //show
    function display()
        global rear;
        global front;
        global CQ;
        disp("Front["+string(front)+"%d]->");
        ind = front;
        while ind~=rear
            disp(string(CQ(ind+1)));
            ind = modulo(ind + 1,TAILLE);
        end
            disp(string(CQ(ind+1)));
            disp("<-["+string(rear)+"]Rear");
    endfunction
    
    //main program
    choice =0;
    while choice~=4 do
        choice = input("1 insert  -  2 delete  - 3  display   4 - stop");
        select choice
    case 1 then
        val = input("Entrez la valeur");
        inser(val);
    case 2 then
        disp(2)
        elem = delet();
       if (elem ~= -1) then
        printf("Deleted Element is %d n", elem);
    end
    case 3 then
        display()
    case 4 then
        return
    else
        disp(3)
    end
end

