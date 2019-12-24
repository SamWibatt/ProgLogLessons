seg[6] = (~dec & val[3] & ~val[1]) | (~dec & ~val[2] & val[1] & val[0]) | (val[3] & ~val[2] & ~val[1]) | (~val[3] & val[2] & ~val[1] & val[0]) | (~val[3] & ~val[2] & val[1]) | (~val[3] & val[1] & ~val[0]) | (~val[2] & ~val[1] & ~val[0]) | (~dec & val[3] & val[2] & ~val[0]);
seg[5] = (~val[3] & val[0]) | (~val[3] & val[2]) | (~dec & ~val[1] & val[0]) | (~val[2] & ~val[1]) | (~dec & val[3] & ~val[2]);
seg[4] = (val[3] & val[1]) | (dec & val[3]) | (val[2] & ~val[1] & val[0]) | (~val[2] & val[1]) | (val[3] & ~val[2]) | (~val[3] & val[2] & ~val[0]);
seg[3] = (~val[3] & val[1] & ~val[0]) | (~val[2] & ~val[1] & ~val[0]) | (~dec & val[3] & val[1]) | (~dec & val[3] & val[2]);
seg[2] = (~dec & ~val[2] & ~val[0]) | (~val[3] & ~val[2]) | (~val[3] & val[1] & val[0]) | (~dec & val[3] & ~val[1] & val[0]) | (~val[2] & ~val[1]) | (~val[3] & ~val[1] & ~val[0]);
seg[1] = (val[3] & ~val[2] & ~val[1]) | (~val[2] & ~val[1] & ~val[0]) | (~val[3] & val[1]) | (~val[3] & val[2] & val[0]) | (~dec & val[2] & val[1]) | (~dec & val[3] & ~val[0]);
seg[0] = (~dec & val[3] & val[1]) | (val[3] & ~val[2] & ~val[1]) | (~dec & val[2] & ~val[0]) | (~val[2] & ~val[1] & ~val[0]) | (~val[3] & val[2] & ~val[1]) | (~val[3] & val[2] & ~val[0]);
