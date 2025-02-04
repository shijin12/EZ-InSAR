function [modepara] = parallelizationstepISCE(namestep,miesar_para)
%   parallelizationstepISCE(namestep,miesar_para)
%       [namestep]      : name of ISCE step
%       [miesar_para]   : user parameters (struct.)
%
%       Function to run, in parallel, the ISCE processing.
%          
%       Script from EZ-InSAR toolbox: https://github.com/alexisInSAR/EZ-InSAR
%
%   See also conversionstacks_SI_IW, isce_switch_stackfunctions, conversionstacks_SI_SM, parallelizationstepISCE, dem_box_cal, iscedisplayifg, removewatermask_ISCEprocessing_SM, isce_preprocessing_S1_IW, runISCEallstep, isce_preprocessing_SM, selectionofstack, isceprocessing.
%
%   -------------------------------------------------------
%   Alexis Hrysiewicz, UCD / iCRAG
%   Version: 1.0.0 Beta
%   Date: 30/11/2021
%
%   -------------------------------------------------------
%   Version history:
%           1.0.0 Beta: Initiale (unreleased)

%% Define the step name

% For SLC stack and IFG stack
stepara = {'run_02_unpack_secondary_slc',...
    'run_05_overlap_geo2rdr',...
    'run_06_overlap_resample',...
    'run_07_pairs_misreg',...
    'run_09_fullBurst_geo2rdr',...
    'run_10_fullBurst_resample',...
    'run_12_merge_reference_secondary_slc',...
    'run_12_unwrap',...
    'run_13_grid_baseline',...
    'run_13_generate_burst_igram',...
    'run_14_merge_burst_igram',...
    'run_15_filter_coherence',...
    'run_15_filter_coherence'}; 

%% Find the index of the selected step(s)
Index = find(cellfun(@(s) ~isempty(strfind(namestep, s)), stepara)==1); 

if isempty(Index)==1
    warning(sprintf('The %s step cannot be parallelized.',namestep));
    modepara = 0;
else
    modepara = 1;
    
    % Ask the number of jobs
    prompt = {sprintf('Number of jobs for %s step',namestep)};
    dlgtitle = 'Parallelization Parameters';
    dims = [1 35];
    definput = {num2str(fix(feature('numcores')./2))}; %50 % of core number
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    hmax = str2num(answer{1});
    if isempty(hmax)==1
        error('The number of core must be a number.');
    end
    
    %Threshold regarding the number of cores
    if hmax > feature('numcores')
        error('The number of core must be lower than the number of available cores.');
    end 
    
    % Write the job files
    fid = fopen([miesar_para.WK,'/run_files/',namestep],'r');
    file = textscan(fid,'%s %s %s'); fclose(fid);
    fid = fopen([miesar_para.WK,'/run_files/',namestep,'_para'],'w');
    h = 1;
    for i1 = 1 : length(file{1})
        if h == hmax
            fprintf(fid,'%s %s %s %s\n',file{1}{i1},file{2}{i1},file{3}{i1},'&');
            fprintf(fid,'wait\n');
            h = 1;
        else
        	fprintf(fid,'%s %s %s %s\n',file{1}{i1},file{2}{i1},file{3}{i1},'&');
        end
        h = h + 1;
    end
    fprintf(fid,'wait\n');
    fclose(fid);
    system(['chmod a+x ',miesar_para.WK,'/run_files/',namestep,'_para']);
end
end
