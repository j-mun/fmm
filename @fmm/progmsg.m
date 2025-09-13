%fmm.progmsg

function [nmsg] = progmsg(o,nmsg,varargin)

%* verbose?
if ~o.opt.verbose; return; end

%* erase previous text
fprintf(repmat('\b',1,nmsg))

%* print new text
msg = varargin{1};
for i = 2:nargin-2
    msg = strcat(msg,varargin{i});
end
msg = strrep(msg,'\n',newline);
msg = strrep(msg,'\t',char(9));
fprintf('%c',msg)
nmsg = length(msg);
return