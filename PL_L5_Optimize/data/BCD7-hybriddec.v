seg[6] = (val[3] & ~val[2] & ~val[1]) | (~val[3] & val[2] & ~val[1] & val[0]) | (~val[3] & val[1] & ~val[0]) | (~val[3] & ~val[2] & val[1]) | (~val[2] & ~val[1] & ~val[0]);
seg[5] = (~val[3] & val[2]) | (~val[3] & val[0]) | (~val[2] & ~val[1]);
seg[4] = (~val[2] & val[1]) | (val[1] & ~val[0]) | (val[2] & ~val[1]) | (val[3]);
seg[3] = (~val[3] & val[1] & ~val[0]) | (~val[2] & ~val[1] & ~val[0]);
seg[2] = (~val[3] & ~val[1] & ~val[0]) | (~val[3] & ~val[2]) | (~val[3] & val[1] & val[0]) | (~val[2] & ~val[1]);
seg[1] = (~val[3] & val[2] & val[0]) | (val[3] & ~val[2] & ~val[1]) | (~val[2] & ~val[1] & ~val[0]) | (~val[3] & val[1]);
seg[0] = (~val[3] & val[2] & ~val[1]) | (val[3] & ~val[2] & ~val[1]) | (~val[3] & ~val[1] & ~val[0]) | (~val[3] & val[2] & ~val[0]);
