function blkStruct = slblocks
% See: https://de.mathworks.com/help/simulink/ug/adding-libraries-to-the-library-browser.html
%
% This function specifies that the library should appear
% in the Library Browser
% and be cached in the browser repository

Browser.Library = 'libMdl_RailwayToolbox'; % name of the library
Browser.Name = 'Railway Toolbox'; % is the library name that appears in the Library Browser

blkStruct.Browser = Browser;

end