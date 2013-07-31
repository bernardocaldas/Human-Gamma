function [ stem ] = resolve_stem(xid,subject,game,varargin)
    stem = sprintf('s%d%02dg%d',xid,subject,game);
end