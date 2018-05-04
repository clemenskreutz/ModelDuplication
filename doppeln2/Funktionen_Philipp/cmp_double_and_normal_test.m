function [arnormal , ardouble] = cmp_double_and_normal(workspace,Setup,m,c)

    global ar;

    arLoad(workspace);
    arSimu(true,true,true);
    ardouble = ar;

    arLoad(Setup);   
    
    %Warum stimmen die Zeitgitter nicht überein?
    cut = min(length(ar.model(m).condition(c).tFine), ...
        length(ardouble.model(m).condition(c).tFine)) + 1;
    
%     time = max(max(ar.model(m).condition(c).tFine), ...
%         max(ardouble.model(m).condition(c).tFine));
%     steps = max(length(ar.model(m).condition(c).tFine), ...
%         length(ardouble.model(m).condition(c).tFine));
    
    arSimu(true,true,true);
        
    if length(ar.model(m).condition(c).tFine) ~= ...
            length(ardouble.model(m).condition(c).tFine)
%         t = 1:(1/steps):time;
%         ar.model(m).condition(c).tFine = t;
%         ardouble.model(m).condition(c).tFine = t;
        if length(ar.model(m).condition(c).tFine) < ...
                length(ardouble.model(m).condition(c).tFine)
            ardouble.model(m).condition(c).tFine(cut:end,:) = [];
            adoubler.model(m).condition(c).xFineSimu(cut:end,:) = [];
            ardouble.model(m).condition(c).vFineSimu(cut:end,:) = [];
            ardouble.model(m).condition(c).uFineSimu(cut:end,:) = [];
            ardouble.model(m).condition(c).zFineSimu(cut:end,:) = [];
            t = ar.model(m).condition(c).tFine;
        else
            ar.model(m).condition(c).tFine(cut:end,:) = [];
            ar.model(m).condition(c).xFineSimu(cut:end,:) = [];
            ar.model(m).condition(c).vFineSimu(cut:end,:) = [];
            ar.model(m).condition(c).uFineSimu(cut:end,:) = [];
            ar.model(m).condition(c).zFineSimu(cut:end,:) = [];
            t = ardouble.model(m).condition(c).tFine;
        end
    end

    arnormal = ar;
    
    
    
    test2 = [max(arnormal.model(m).condition(c).tFine) , ...
        max(ardouble.model(m).condition(c).tFine)];
    %Check
    if t == ardouble.model(m).condition(c).tFine
        test = 'tFine grid is identical';
        disp(test);
        disp(test2);
    else
        test = 'tFine grid is NOT identical';
        disp(test);
        disp(test2);
    end
    
    %x-values
    if isempty(arnormal.model(m).condition(c).xFineSimu) || ...
            ~any(arnormal.model(m).condition(c).xFineSimu(:) ~= 0)
        return
    else
        xdFine = ardouble.model(m).condition(c).xFineSimu;
        xnFine = arnormal.model(m).condition(c).xFineSimu;            
        x_size = size(xnFine);
        if xdFine(:,1:x_size(1,2)) == xnFine
            x_msg = 'X-values are the same';
            disp(x_msg);
        else
            for k = 1:x_size(1,2)
                if k == 1
                    x_diff = figure('Name','X_diff','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(t, xdFine(:,k) - xnFine(:,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(t, xdFine(:,k) - xnFine(:,k));
                else
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(t, xdFine(:,k) - xnFine(:,k));
                end
            end
            for k = 1:x_size(1,2)
                if k == 1
                    xfig = figure('Name','X','NumberTitle','off');
                end
                if mod(k,2) == 1
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(t, xdFine(:,k), t, xnFine(:,k)); 
                elseif mod(k,2) == 2
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(t, xdFine(:,k), t, xnFine(:,k)); 
                else
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(t, xdFine(:,k), t, xnFine(:,k)); 
                end
            end
        end        
    end
        
    %v-values
    if isempty(arnormal.model(m).condition(c).vFineSimu) || ...
            ~any(arnormal.model(m).condition(c).vFineSimu(:) ~= 0)
        return
    else
        vdFine = ardouble.model(m).condition(c).vFineSimu;
        vnFine = arnormal.model(m).condition(c).vFineSimu;
        v_size = size(vnFine);
        if vdFine(:,1:v_size(1,2)) == vnFine
            v_msg = 'V-values are the same';
            disp(v_msg);
        else
            for k = 1:v_size(1,2)
                if k == 1
                    v_diff = figure('Name','V_diff','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(t, vdFine(:,k) - vnFine(:,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(t, vdFine(:,k) - vnFine(:,k));
                else
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(t, vdFine(:,k) - vnFine(:,k));
                end
            end
            for k = 1:v_size(1,2)
                if k == 1
                    vfig = figure('Name','V','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(t, vdFine(:,k), t, vnFine(:,k)); 
                elseif mod(k,2) == 2 
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(t, vdFine(:,k), t, vnFine(:,k)); 
                else
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(t, vdFine(:,k), t, vnFine(:,k)); 
                end 
            end
        end        
    end

    %u-values
    if isempty(arnormal.model(m).condition(c).uFineSimu) || ...
            ~any(arnormal.model(m).condition(c).uFineSimu(:) ~= 0)
        return
    else
        udFine = ardouble.model(m).condition(c).uFineSimu;
        unFine = arnormal.model(m).condition(c).uFineSimu;
        u_size = size(unFine);
        if udFine(:,1:u_size(1,2)) == unFine
            u_msg = 'U-values are the same';
            disp(u_msg);
        else
            for k = 1:u_size(1,2)
                if k == 1
                    u_diff = figure('Name','U_diff','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(t, udFine(:,k) - unFine(:,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(t, udFine(:,k) - unFine(:,k));
                else
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(t, udFine(:,k) - unFine(:,k));
                end 
            end
            for k = 1:u_size(1,2)
                if k == 1
                    ufig = figure('Name','U','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(t, udFine(:,k), t, unFine(:,k)); 
                elseif mod(k,2) == 2 
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(t, udFine(:,k), t, unFine(:,k)); 
                else
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(t, udFine(:,k), t, unFine(:,k)); 
                end 
            end
        end        
    end
    
    %z-values
    if isempty(arnormal.model(m).condition(c).zFineSimu) || ...
            ~any(arnormal.model(m).condition(c).zFineSimu(:) ~= 0)
        return
    else
        zdFine = ardouble.model(m).condition(c).zFineSimu;
        znFine = arnormal.model(m).condition(c).zFineSimu;
        z_size = size(znFine);
        if zdFine(:,1:z_size(1,2)) == znFine
            z_msg = 'Z-values are the same';
            disp(z_msg);
        else
            for k = 1:z_size(1,2)
                if k == 1
                    z_diff = figure('Name','Z_diff','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(t, zdFine(:,k) - znFine(:,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(t, zdFine(:,k) - znFine(:,k)); 
                else
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(t, zdFine(:,k) - znFine(:,k));
                end 
            end
            for k = 1:z_size(1,2)
                if k == 1
                    zfig = figure('Name','Z','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(t, zdFine(:,k), t, znFine(:,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(t, zdFine(:,k), t, znFine(:,k));
                else
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(t, zdFine(:,k), t, znFine(:,k));
                end
            end
        end        
    end
end

    
    
    
    
        