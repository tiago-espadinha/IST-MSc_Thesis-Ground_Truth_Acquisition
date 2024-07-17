function vrml_textured_model( xyz, facesList, modelFileName )
%
% function vrml_textured_model(xyz, facesList, modelFileName)
%
% Create a VRML model from 3D points organised as a set of faces
% (polygons) whose texture is available in one or more images.
%
% xyz : 3xN : 3D points
%
% facesList : collection of faces each one described by
%             1) a set of indexes representing columns of xyz and
%                thus defining a frontier polygon in 3D (1xN)
%             2) a corresponding set of 2D points (2xN) in a texture image,
%                one foreach index
%             3) the texture image (filename)
%             General syntax:
%               { polygon1, uv1, "texFName1"; ...
%                 polygon2, uv2, "texFName2"; ...
%                 ...
%                 polygonM, uvM, "texFNameM" }
%             If the texFName is always the same then all the polygons
%             may be specified as a list in "polygon1" placing then in
%             "uv1" all corresponding 2D coords:
%               { polygons, uv, "texFName" }
%
% modelFileName : str : output filename
%             

% Auxiliary functions (also in this .m):
%  function s = vrml_polygons(x, f, uv, texFName)
%  function v = list2vector( l )
%  function facesList2= check_args( xyz, facesList, modelFileName )

% 02/05/2001 (v0 based on original code by E. Grossmann), J. Gaspar

if nargin<3,
   error('not enough arguments');
end
facesList= check_args( xyz, facesList, modelFileName );

fid= fopen(modelFileName, 'wt');
fprintf(fid, '#VRML V2.0 utf8\n');
for i=1:size(facesList,1),
   %
   polygons= facesList{i,1};
   uv=       facesList{i,2};
   texFName= facesList{i,3};
   %
   str= vrml_polygons(xyz, polygons, uv, texFName);
   fprintf(fid, '%s', str);
end
fclose(fid);

return; % end of function


% -------- aux fn:
%
function str = vrml_polygons(x, f, uv, texFName)
%
% function str = vrml_polygons(x, f, uv, texFName)
%
% Create a texture mapped 3D model in vrml from polygons
% defined over 3D points and their projections on
% a texture image.
%
% x : 3xN  : 3D points
% f : list : indexes into x defining poligons
%             (each el in the list is a polygon)
% uv: 2xN  : image coordinates of polygon vertices (values in [0,1])
% texFName: str : filename of the image containing the texture
% 

% 15/02/01 (original code: vrml_faces.m), E. Grossmann
% 26/04/01 (conv. from octave to matlab;
%           implemented only texture mapping),
% 27/04/01 (f is a list of polygons; does not need to be triangles), J. Gaspar

if ~iscell(f),
   f= {f};
end

% write texture image filename into the model
%
col_str_1 = sprintf (['  appearance Appearance {\n',...
			'    texture ImageTexture {\n',...
			'      url "%s"\n',...
			'    }\n',...
			'  }\n'],...
		       texFName);

% write 2D point coords and their organising polygonal net
%
col_str_2 = sprintf (['  texCoord TextureCoordinate {\n',...
			'    point [\n      %s]\n',...
			'  }\n',...
			],...
		   sprintf ('%10.8f %10.8f,\n      ', uv) ...
         );
%
nfaces = length(f);
tmp= '  texCoordIndex [\n';
n= 0;
for i= 1:nfaces
   for j= 0:(length(f{i})-1)
      tmp= [tmp sprintf('%4d ', n)];
      n= n+1;
   end
   tmp= [tmp sprintf('-1\n')];
end
%
col_str_2= [col_str_2 tmp ']\n' ];

% write 3D polygonal net in to the model (3D points are
%  writen in the last printf)
%
coord_str = '';
for i = 1:nfaces
   tmp= ['                 ' sprintf('%d ', f{i}-1)];
   coord_str= [ coord_str tmp sprintf('-1 \n')];
end

% additional string for extra options
%
etc_str = ['    convex FALSE\n'];

% finally the string of the indexed face set
%
str = sprintf([...
      'Shape {\n',...
	     col_str_1,... % texture FName
	     '  geometry IndexedFaceSet {\n',...
	     '    solid FALSE     # Show back of faces too\n',...
	     col_str_2,... % texture coordinates
	     etc_str,...
	     '    coordIndex [\n%s]\n',...
	     '    coord Coordinate {\n',...
	     '      point [\n%s]\n',...
	     '    }\n',...
	     '  }\n',...
	     '}\n',...
	     ],...
	    coord_str,...
	    sprintf('                 %8.3f %8.3f %8.3f,\n',x)) ;

return; % end of function


% -------- aux fn:
%
function facesList2= check_args( xyz, facesList, modelFileName )
%
% xyz : 3xP : P 3D points
%
if size(xyz,1)~=3,
   error('arg "xyz", number of lines is different of 3');
end

% modelFileName : string
%
if ~ischar(modelFileName),
   error('arg "modelFileName" is not a string.');
end

% facesList : list with size Nx3 (or that can be reshaped to this size)
%             facesList{i,1} is vector or list of vectors
%             facesList{i,2} is 2xN array
%             facesList{i,3} is string
%
if size(facesList,1)==1 | size(facesList,2)==1,
   %
   if length(facesList)<3,
      error('arg facesList: missing data (length < 3)')
   end
   n= length(facesList)/3;
   if abs( n - round(n) ) > 1e-6,
      error('arg facesList: uncomplete data (num elements not multiple of 3)')
   end
   facesList2= reshape(facesList, 3,n)';
else
   if size(facesList,2)~=3,
      error('arg facesList: num columns is not 3 (list is transposed?)')
   end
   facesList2= facesList;
end
%
% make polygon sub-arg always a list, check uvX size, check texFNameX is str
%
for i=1:size(facesList2,1),
   %
   s= num2str(i);
   %
   if ~iscell(facesList2{i,1}),
      facesList2{i,1}= { facesList2{i,1} };
   end
   %
   uv= facesList2{i,2};
   if size(uv,1) ~= 2,
      error(['arg facesList: num of lines of uv' s ...
            ' is not 2 (is transposed?)'])
   end
   if max(max(uv))>1,
      error(['arg facesList: uv' s ' have coordinates bigger than 1 '...
         '( (0,0)=bot_left (1,1)=top_right )'])
   end
   if min(min(uv))<0,
      warning(['arg facesList: uv' s ' negative coordinates '...
         '( (0,0)=bot_left (1,1)=top_right )'])
   end
   %
   N=0; l=facesList2{i,1}; for j=1:length(l), N= N+length(l{j}); end
   if N ~= size(uv),
      error(['arg facesList: num of points in uv' s ...
            ' differs from the number of indexes in polygon' s '.'])
   end
   %
   if ~ischar(facesList2{i,3}),
      error(['arg facesList: textFName' s ' is not a string.'])
   end
   %
end
%
return; % end of function


% -------- aux fn:
%
function v = list2vector( l )
%
v= [];
for i=1:length(l),
   a= l{i};
   v= [v a(:)'];
end
return; % end of function
