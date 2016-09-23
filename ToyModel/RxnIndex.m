function [ index ] = RxnIndex( ReactionName, Reactions )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
index = find(strcmp(ReactionName,Reactions));


end

