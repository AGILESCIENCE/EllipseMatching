% Naive matching

clear all
close all
clc

arg_list = argv ();

fname1 = arg_list{1};
fname2 = arg_list{2};
outfname = arg_list{3};


e1 = ellload(fname1);
e2 = ellload(fname2);

fid = fopen(outfname, 'w');

fprintf('** DEBUG MODE ON **\n');


%fprintf(fid, 'Match %s with %s\n', fname1, fname2);

for i = 1 : length(e1)

    % fprintf(fid, '[%05d] %s\n', i, e1(i).name);
    fprintf('\n\n[%05d] %s\n', i, e1(i).name);

    for j = 1 : length(e2)



       	% Check if they are equal
       	if(e1(i).x == e2(j).x && e1(i).y == e2(j).y && e1(i).a == e2(j).a && e1(i).b == e2(j).b && e1(i).p == e2(j).p)

       		fprintf(fid, '[%05d] %s is equal to [%05d] %s--2 %s %3.3f %3.2f %f %f %f\n', j, e2(j).name, i,  e1(i).name, e2(j).name, e2(j).x,e2(j).y, e2(j).a, e2(j).b, e2(j).p);
        	fprintf('[%05d] %s is equal to [%05d] %s--2 %s %3.3f %3.2f %f %f %f\n', j, e2(j).name, i,  e1(i).name, e2(j).name, e2(j).x,e2(j).y, e2(j).a, e2(j).b, e2(j).p);
       	else

       		% Check if overlapping is possible using radius
    			dx = e2(j).x - e1(i).x;
    			dy = e2(j).y - e1(i).y;
    			d  = sqrt(dx^2 + dy^2);

    			% Accurate overlapping
    			if d <= e2(j).r + e1(i).r

            % One degree rotation if the axis are parallel
            if (  abs(e1(i).p - e2(j).p)   ) <= 1e-6
              fprintf('\n==> Ellipses are parallel!! e1.p: %f  e2.p: %f    e1.p-e2.p= %f',e1(i).p ,e2(j).p, e1(i).p -e2(j).p )
              e1(i).p = e1(i).p + 1*pi/180;
              fprintf('\n==> Ellipses new rotation: e1.p: %f  e2.p: %f',e1(i).p ,e2(j).p )
            end



    				if isempty(e1(i).C)
    					[e1(i).C,e1(i).D,e1(i).R,e1(i).M] = ellmatrix(e1(i).x, e1(i).y, e1(i).a, e1(i).b, e1(i).p);
    				end

    				if isempty(e2(j).C)
    					[e2(j).C,e2(j).D,e2(j).R,e2(j).M] = ellmatrix(e2(j).x, e2(j).y, e2(j).a, e2(j).b, e2(j).p);
    				end

    				res = elltest(e1(i).C, e1(i).D, e1(i).R, e1(i).M, e2(j).C, e2(j).D, e2(j).R, e2(j).M, 1e-6);

    				% fprintf(fid, '   [%05d] %s %s\n', j, e2(j).name, ellmsg(res));
    				[res,code] = ellmsg(res);
    				fprintf(fid, '[%05d] %s %s [%05d] %s--%s %s %3.3f %3.2f %f %f %f\n', j, e2(j).name, res, i,  e1(i).name,code, e2(j).name, e2(j).x,e2(j).y, e2(j).a, e2(j).b, e2(j).p);
    				fprintf( '[%05d] %s %s [%05d] %s--%s %s %3.3f %3.2f %f %f %f\n', j, e2(j).name, res, i, e1(i).name,code, e2(j).name, e2(j).x,e2(j).y, e2(j).a, e2(j).b, e2(j).p);

    			else

    				fprintf(fid, '[%05d] %s is external to [%05d] %s--7 %s %3.3f %3.2f %f %f %f\n', j, e2(j).name, i,  e1(i).name, e2(j).name, e2(j).x,e2(j).y, e2(j).a, e2(j).b, e2(j).p);
    				fprintf( '[%05d] %s is external to [%05d] %s--7 %s %3.3f %3.2f %f %f %f\n', j, e2(j).name, i,  e1(i).name, e2(j).name, e2(j).x,e2(j).y, e2(j).a, e2(j).b, e2(j).p);

    			end
       	end


    end

end

disp("END OF THE PROGRAM")


fclose(fid);
