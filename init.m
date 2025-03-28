function [] = init(year,full_name,args)
arguments
    year (1,1) int32
    full_name char
    args.self_delete (1,1) logical = true;
    args.reset_test (1,1) logical = true;
end

print_info();
print_logo();

% Reset MATLAB code examples
reset_file('main.m','function varargout = main(varargin)\nend\n');
rmdir('src','s');
mkdir('src');

% Reset repository files
reset_file('CHANGELOG.md');
reset_file('.release-please-manifest.json', '{}\n');
reset_file('.gitattributes', '\n');
reset_file('version.txt', '0.0.1\n');
reset_file('README.md', ['# README\n\n',...
                         '![CI](../../actions/workflows/ci.yml/badge.svg?branch=main)\n']);
if args.reset_test
    reset_file('test.m','assert(true);\n');
end

syncMirrorWorkflowPath = fullfile(pwd, '.github/workflows/sync-mirror.yml');
delete(syncMirrorWorkflowPath)

rmdir('.github/actions','s');

% Set license details
set_license('LICENSE',year,full_name);

if ~args.self_delete
    return;
end

% self-delete template resetter
this_file = mfilename();
delete(which(this_file));

end

function reset_file(name,lines)
arguments
    name char
    lines char = ''
end

full_file = fullfile(pwd, name);
[fid, err_msg] = fopen(full_file, 'w');

if fid == -1
    error(['Could not open ', name,' for writing: ',err_msg]);
end

fprintf(fid, lines);
fclose(fid);
fprintf([name, ' has been reset.\n']);
end


function set_license(file_name,year,full_name)
full_file = fullfile(pwd, file_name);

[fid, err_msg] = fopen(full_file,'r');
if fid == -1
    error(['Could not open ', name,' for reading: ',err_msg]);
end
license_text=fread(fid,'*char')';
fclose(fid);

upd_license_text = regexprep(license_text,'Copyright \(c\) (.*?)\n', ...
    ['Copyright (c) ',num2str(year),', ', full_name,'\n']);

[fid, err_msg] = fopen(full_file,'w');
if fid == -1
    error(['Could not open ', name,' for writing: ',err_msg]);
end
fprintf(fid,'%s',upd_license_text);
fclose(fid);
end

function print_info()
[fid, ~] = fopen('version.txt','r');
version_str=fread(fid,'*char')';
fclose(fid);

fprintf('%s%s',"matlab-repo-init v",version_str);
end

function print_logo()
fprintf(...
"                               ▄▄▄▄\n" + ...
"                        ▄▟██████████████▙▄\n" + ...
"    $> matlab init    ▄▟███▛          ▜███▙▄\n" + ...
"                     ▟██▛                ▜██▙\n" + ...
"▜██▙                ▟██▛\n" + ...
" ▀▜███▙          ▟███▛▀\n" + ...
"   ▀▜██████████████▛▀\n" + ...
"          ▀▀▀▀\n" + ...
"                               ▄▄▄▄\n" + ...
"                        ▄▟██████████████▙▄\n" + ...
"                      ▄▟███▓░░░░░░░░░░▓███▙▄\n" + ...
"                     ▟██▓░░░░░░░░░░░░░░░░▓██▙\n" + ...
"▓██▙                ▟██▓░░░░░░░░░░░░░░░░░░░░░\n" + ...
"░▒▓███▙          ▟███▓▒░░░░░░░░▒▓▓▒░░░░░░░░░░\n" + ...
"░░░▒▓██████████████▓▒░░░▒▓██████████████▓▒░░░\n" + ...
"░░░░░░░░░▒▓▓▒░░░░░░░░░▒▓███▛          ▜███▓▒░\n" + ...
"░░░░░░░░░░░░░░░░░░░░░▓██▛                ▜██▓\n" + ...
"▜██▓░░░░░░░░░░░░░░░░▓██▛\n" + ...
" ▀▜███▓░░░░░░░░░░▓███▛▀   $> git commit\n" + ...
"   ▀▜██████████████▛▀\n" + ...
"         ▀▀▀▀\n" + ...
"\n");
end
