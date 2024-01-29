function [VN_ENT] = ENT3C(M,CELL_TYPE,BR,ChrNr,BIN_TABLE_RED,Resolution,MAX_WINDOWS,CHRSPLIT,SUB_M_SIZE_FIX,WS)
% INPUT VARS

%   M ... input matrix
%   CELL_TYPE ... name of cell-type to save in output table
%   BR ... biological replicate (nan if NA)
%   Resolution=40e3; ... resolution of cool/to extract from mcool file
%   SUB_M_SIZE_FIX ... fixed submatrix size n
%   CHRSPLIT=10; ... determines window/sub-matrix size on which entropy values S(window) are calculated on
%   WS ... shift size of submatrix alon diagonal
%   MAX_WINDOWS=500; ... maximum number of entropy values to compute (window shift is increased until desired window number is reached)

% OUTPUT VARS
%   VN_ENT ... output table with entropy values and other information

VN_ENT=[];S_signal=[];
if SUB_M_SIZE_FIX==0||isnan(SUB_M_SIZE_FIX)
    SUB_M_SIZE=round(size(M,1)/CHRSPLIT);
    WN=1+floor((size(M,1)-SUB_M_SIZE)./WS);
    while WN>MAX_WINDOWS
        WS=WS+1;
        WN=1+floor((size(M,1)-SUB_M_SIZE)./WS);
    end
else
    SUB_M_SIZE=SUB_M_SIZE_FIX;
    WN=1+floor((size(M,1)-SUB_M_SIZE)./WS);
    while WN>MAX_WINDOWS
        WS=WS+1;
        WN=1+floor((size(M,1)-SUB_M_SIZE)./WS);
    end
end

WN=1+floor((size(M,1)-SUB_M_SIZE)./WS);
R1=1:WS:size(M,1);R1=R1(1:WN);
R2=R1+SUB_M_SIZE-1;R2=R2(1:WN);
R=[R1',R2'];

for rr=1:WN
    m=log(M(R(rr,1):R(rr,2),R(rr,1):R(rr,2)));
    f=find(isnan(m));
    m(f)=nanmin(m(:));
    P = corrcoef(m,'rows','complete');
    f=find(isnan(P));P(f)=0;
    rho=P./size(P,1);

    lam = eig(full(rho));
    lam = lam(lam>0); 

    S = -sum(real(lam.*log(lam)));

     VN_ENT=[VN_ENT;table({CELL_TYPE},BR,ChrNr,Resolution,SUB_M_SIZE,WN,WS,...
            BIN_TABLE_RED.binNrCHRS(R(rr,1)),BIN_TABLE_RED.binNrCHRS(R(rr,2)),BIN_TABLE_RED.START(R(rr,1)),BIN_TABLE_RED.END(R(rr,2)),S,...
            'VariableNames',{'Name','BR','ChrNr','Resolution','Sub_M_Size','WinNrs','WS',...
            'binNrCHRS_start','binNrCHRS_end','start','end','S'})];

       S_signal=[S_signal;S];

end








