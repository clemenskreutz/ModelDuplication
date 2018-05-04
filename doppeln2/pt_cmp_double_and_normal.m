function [arnormal , ardouble] = cmp_double_and_normal(workspace,Setup,m,c)

    global ar;

    arLoad(workspace);
    arSimu(true,true,true);
    ardouble = ar;

    arLoad(Setup);
    arSimu(true,true,true);   

    arnormal = ar;
    
    test = length(ardouble.model(m).condition(c).tFine) ~= ...
        length(arnormal.model(m).condition(c).tFine) 
    
    if test
        msg = 'tFine grids NOT identical';
        disp(msg);
    end

    %x-values
    if isempty(arnormal.model(m).condition(c).xFineSimu) || ...
            ~any(arnormal.model(m).condition(c).xFineSimu(:) ~= 0)
        return
    else
        xdFine = ardouble.model(m).condition(c).xFineSimu;
        xnFine = arnormal.model(m).condition(c).xFineSimu;            
        x_size = size(xnFine);
        if sum(xdFine(:,1:x_size(1,2))) == sum(xnFine)
            x_msg = 'X-values are the same';
            disp(x_msg);
        else
            for k = 1:x_size(1,2)
                if k == 1
                    x_diff = figure('Name','X_diff_test','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, xdFine(:,k) - xdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, xnFine(:,k) - xnFine(1,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, xdFine(:,k) - xdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, xnFine(:,k) - xnFine(1,k))
                else
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, xdFine(:,k) - xdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, xnFine(:,k) - xnFine(1,k))
                end
            end
            for k = 1:x_size(1,2)
                if k == 1
                    xfig = figure('Name','X_test','NumberTitle','off');
                end
                if mod(k,2) == 1
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, xdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, xnFine(:,k)); 
                elseif mod(k,2) == 2
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, xdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, xnFine(:,k)); 
                else
                    subplot(ceil(x_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, xdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, xnFine(:,k)); 
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
        if sum(vdFine(:,1:v_size(1,2))) == sum(vnFine)
            v_msg = 'V-values are the same';
            disp(v_msg);
        else
            for k = 1:v_size(1,2)
                if k == 1
                    v_diff = figure('Name','V_diff_test','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, vdFine(:,k) - vdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, vnFine(:,k) - vnFine(1,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, vdFine(:,k) - vdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, vnFine(:,k) - vnFine(1,k))
                else
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, vdFine(:,k) - vdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, vnFine(:,k) - vnFine(1,k))
                end
            end
            for k = 1:v_size(1,2)
                if k == 1
                    vfig = figure('Name','V_test','NumberTitle','off');
                end
                if mod(k,2) == 1
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, vdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, vnFine(:,k)); 
                elseif mod(k,2) == 2
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, vdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, vnFine(:,k)); 
                else
                    subplot(ceil(v_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, vdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, vnFine(:,k)); 
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
        if sum(udFine(:,1:u_size(1,2))) == sum(unFine)
            u_msg = 'U-values are the same';
            disp(u_msg);
        else
            for k = 1:u_size(1,2)
                if k == 1
                    u_diff = figure('Name','U_diff_test','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, udFine(:,k) - udFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, unFine(:,k) - unFine(1,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, udFine(:,k) - udFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, unFine(:,k) - unFine(1,k))
                else
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, udFine(:,k) - udFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, unFine(:,k) - unFine(1,k))
                end
            end
            for k = 1:u_size(1,2)
                if k == 1
                    ufig = figure('Name','U_test','NumberTitle','off');
                end
                if mod(k,2) == 1
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, udFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, unFine(:,k)); 
                elseif mod(k,2) == 2
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, udFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, unFine(:,k)); 
                else
                    subplot(ceil(u_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, udFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, unFine(:,k)); 
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
        if sum(zdFine(:,1:z_size(1,2))) == sum(znFine)
            z_msg = 'Z-values are the same';
            disp(z_msg);
        else
            for k = 1:z_size(1,2)
                if k == 1
                    z_diff = figure('Name','Z_diff_test','NumberTitle','off');
                end
                if mod(k,2) == 1 
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, zdFine(:,k) - zdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, znFine(:,k) - znFine(1,k));
                elseif mod(k,2) == 2 
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, zdFine(:,k) - zdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, znFine(:,k) - znFine(1,k))
                else
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, zdFine(:,k) - zdFine(1,k), ...
                        arnormal.model(m).condition(c).tFine, znFine(:,k) - znFine(1,k))
                end
            end
            for k = 1:z_size(1,2)
                if k == 1
                    zfig = figure('Name','Z_test','NumberTitle','off');
                end
                if mod(k,2) == 1
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, zdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, znFine(:,k)); 
                elseif mod(k,2) == 2
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, zdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, znFine(:,k)); 
                else
                    subplot(ceil(z_size(1,2)/3),3,k);
                    plot(ardouble.model(m).condition(c).tFine, zdFine(:,k), ...
                        arnormal.model(m).condition(c).tFine, znFine(:,k)); 
                end
            end
        end        
    end 
end

    
    
    
    
        