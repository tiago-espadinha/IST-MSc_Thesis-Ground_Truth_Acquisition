function data= multitasking_data(dataId, fieldname)
%
% dataId : string
% fieldname : string : [facultative]
%
% data : struct : dataId field + variable fields


if nargout<1
    multitasking_data_demo;
    return
end

if nargin<1
    dataId= 'buspath1'; %0;
end
if isnumeric(dataId)
    dataId= num2str(dataId);
end
if nargin<2
    fieldname= '';
end

p= which('multitasking_data.m'); p= strrep(p, 'multitasking_data.m', '');

% general data definition
%
switch dataId
    case '0'
        data= multitasking_data('buspath1');
        
    case {'buspath1', 'buspath2', 'buspath3', 'buspath4', ...
            'v_phi1', 'v_phi2', 'v_phi3', 'v_phi4' }
        x= load([p dataId]);
        %data= struct('dataId',dataId, 'p',p, 'buspath', x.buspath);
        data= struct('dataId',dataId, 'p',p, 'x', x);
        
    otherwise
        error('invalid dataId')
end

% specific "fieldname" data
%
if ~isempty(fieldname)
    data= fieldnamestree('data', fieldname);
end

return
