function [y, errFlag]= fieldnamestree(bsname, fieldname)
%
% Return all fieldnames in a structure,
% or return the value of a given fieldname
%
% bsname: string : the name of a structure
% fieldname: string : [facultative] the name of a field to find
% y: Nx2 list or generic value
%
% Usages:
% y= fieldnamestree(bsname); % return Nx2 list
% y= fieldnamestree(bsname, fieldname); % return a value

% 26.5.2013, JG

if nargin<1
    demo
    return
end
if nargin<2
    fieldname= [];
end

if ~ischar(bsname)
    error('bsname is not a string')
end

% find all fieldnames & subfieldnames
%
y= {};
s= evalin('caller', bsname);
y= add_fieldnames(y, bsname, s);
errFlag= 0;

if isempty(fieldname), return; end; % nothing more to do

% find the value of a specific fieldname
%
found= 0;
for i=1:size(y,1)
    tmp= y{i,2};
    for j=1:length(tmp)
        if strcmp(tmp{j}, fieldname)
            found= 1;
            break;
        end
    end
    if found, break; end
end
if found
    y= evalin('caller', [y{i} '.' fieldname]);
else
    y= [];
    errFlag= 1;
end

return; % end of main function


function y= add_fieldnames(y, bsname, s)
fn= fieldnames(s);
y{end+1,1}= bsname; y{end,2}= fn;
for i=1:length(fn)
    bsname2= [bsname '.' fn{i}];
    s2= getfield(s, fn{i});
    if isstruct(s2)
        y= add_fieldnames(y, bsname2, s2);
    end
end


function demo
a= struct('a1',1, 'a2',2, 'a3',3);
b= struct('b1',a, 'b2',[], 'b3',a);
c= struct('c1',b, 'c2',[]);
y= fieldnamestree('c');
y
z= fieldnamestree('c', 'a3');
z
return
