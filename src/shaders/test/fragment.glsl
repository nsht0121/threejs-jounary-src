#define PI 3.1415926535897932384626433832795

varying vec2 vUv;

float random(vec2 st)
{
  return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 mid)
{
  return vec2(
    cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
    cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
  );
}

vec4 permute(vec4 x)
{
  return mod(((x*34.0)+1.0)*x, 289.0);
}

vec2 fade(vec2 t)
{
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = permute(permute(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);
  vec4 norm = 1.79284291400159 - 0.85373472095314 * vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

void main()
{
  // // Pattern 1: blue map
  // gl_FragColor = vec4(vUv, 1.0, 1.0);

  // // Pattern 2: green map
  // gl_FragColor = vec4(vUv, 0.5, 1.0);

  // // Pattern 3: gradient x
  // float strength = vUv.x;

  // // Pattern 4: gradient y
  // float strength = vUv.y;

  // // Pattern 5: inverse gradient y
  // float strength = 1.0 - vUv.y;

  // // Pattern 6: gradient y, fast
  // float strength = vUv.y * 10.0;

  // // Pattern 7: gardient stripe
  // float strength = mod(vUv.y * 10.0, 1.0);

  // // Pattern 8: stripe
  // float strength = step(0.5, mod(vUv.y * 10.0, 1.0));

  // // Pattern 9: thin stripe
  // float strength = step(0.8, mod(vUv.y * 10.0, 1.0));

  // // Pattern 10: thin stripe, x
  // float strength = step(0.8, mod(vUv.x * 10.0, 1.0));

  // // Pattern 11: grid
  // float strength = step(0.8, mod(vUv.x * 10.0, 1.0)) + step(0.8, mod(vUv.y * 10.0, 1.0));

  // // Pattern 12: dot
  // float strength = step(0.8, mod(vUv.x * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0, 1.0));

  // // Pattern 13: hyphen
  // float strength = step(0.4, mod(vUv.x * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0, 1.0));

  // // Pattern 14: mirrored L
  // float barX = step(0.4, mod(vUv.x * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0, 1.0));
  // float barY = step(0.8, mod(vUv.x * 10.0, 1.0)) * step(0.4, mod(vUv.y * 10.0, 1.0));
  // float strength = barX + barY;

  // // Pattern 15: plus
  // float barX = step(0.4, mod(vUv.x * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0 + 0.2, 1.0));
  // float barY = step(0.8, mod(vUv.x * 10.0 + 0.2, 1.0)) * step(0.4, mod(vUv.y * 10.0, 1.0));
  // float strength = barX + barY;

  // // Pattern 16: gardient, dim at middle
  // float strength = abs(vUv.x - 0.5);

  // // Pattern 17: gardient, plus
  // float strength = min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

  // // Pattern 18: gardient, x star
  // float strength = max(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

  // // Pattern 19: thick square
  // float strength = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));

  // // Pattern 20: thin square
  // float square1 = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
  // float square2 = 1.0 - step(0.25, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
  // float strength = square1 * square2;

  // // Pattern 21: step gardient
  // float strength = floor(vUv.x * 10.0) / 10.0;

  // // Pattern 22: grid step gradient
  // float strength = floor(vUv.x * 10.0) / 10.0 * floor(vUv.y * 10.0) / 10.0;

  // // Pattern 23: noise
  // float strength = random(vUv);

  // // Pattern 23: large noise
  // vec2 gridUv = vec2(
  //   floor(vUv.x * 10.0) / 10.0,
  //   floor(vUv.y * 10.0) / 10.0
  // );
  // float strength = random(gridUv);

  // // Pattern 24: shifted large noise
  // vec2 gridUv = vec2(
  //   floor(vUv.x * 10.0) / 10.0,
  //   floor((vUv.x + vUv.y) * 10.0) / 10.0
  // );
  // float strength = random(gridUv);

  // // Pattern 25: bottom left radial shadow
  // float strength = length(vUv);

  // // Pattern 26: center radial shadow (1)
  // float strength = length(vUv - 0.5);
  
  // // Pattern 27: center radial shadow (2)
  // float strength = distance(vUv, vec2(0.5));

  // // Pattern 28: spotlight
  // float strength = 1.0 - distance(vUv, vec2(0.5));

  // // Pattern 29: small spotlight
  // float strength = 0.02 / distance(vUv, vec2(0.5));

  // // Pattern 30: stretched small spotlight
  // vec2 lightUv = vec2(
  //   vUv.x,
  //   (vUv.y - 0.5) * 5.0 + 0.5
  // );
  // float strength = 0.15 / distance(lightUv, vec2(0.5));

  // // Pattern 31: star
  // vec2 lightUvX = vec2(vUv.x, (vUv.y - 0.5) * 5.0 + 0.5);
  // float lightX = 0.15 / distance(lightUvX, vec2(0.5));
  // vec2 lightUvY = vec2(vUv.y, (vUv.x - 0.5) * 5.0 + 0.5);
  // float lightY = 0.15 / distance(lightUvY, vec2(0.5));
  // float strength = lightX * lightY;

  // // Pattern 32: rotated star
  // vec2 rotatedUv = rotate(vUv, PI * 0.25, vec2(0.5));
  // vec2 lightUvX = vec2(rotatedUv.x, (rotatedUv.y - 0.5) * 5.0 + 0.5);
  // float lightX = 0.15 / distance(lightUvX, vec2(0.5));
  // vec2 lightUvY = vec2(rotatedUv.y, (rotatedUv.x - 0.5) * 5.0 + 0.5);
  // float lightY = 0.15 / distance(lightUvY, vec2(0.5));
  // float strength = lightX * lightY;

  // // Pattern 33: black filled circle
  // float strength = step(0.25, distance(vUv, vec2(0.5)));

  // // Pattern 34: black radial circle
  // float strength = abs(distance(vUv, vec2(0.5)) - 0.25);

  // // Pattern 35: black circle
  // float strength = step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));

  // // Pattern 36: white circle
  // float strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));

  // // Pattern 37: white circle wave
  // vec2 waveUv = vec2(
  //   vUv.x,
  //   vUv.y + sin(vUv.x * 30.0) * 0.1
  // );
  // float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));

  // // Pattern 38: splat
  // vec2 waveUv = vec2(
  //   vUv.x + sin(vUv.y * 30.0) * 0.1,
  //   vUv.y + sin(vUv.x * 30.0) * 0.1
  // );
  // float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));

  // // Pattern 39: splat (2)
  // vec2 waveUv = vec2(
  //   vUv.x + sin(vUv.y * 100.0) * 0.1,
  //   vUv.y + sin(vUv.x * 100.0) * 0.1
  // );
  // float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));

  // // Pattern 40: angle
  // float strength = atan(vUv.x, vUv.y);

  // // Pattern 41: offset angle
  // float strength = atan(vUv.x - 0.5, vUv.y - 0.5);

  // // Pattern 42: full offset angle
  // float strength = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0) + 0.5;

  // // Pattern 43: fan
  // float angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0) + 0.5;
  // float strength = mod(angle * 20.0, 1.0);

  // // Pattern 44: fan (2)
  // float angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0) + 0.5;
  // float strength = sin(angle * 100.0);

  // // Pattern 45: spike circle
  // float angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0) + 0.5;
  // float sinusoid = sin(angle * 100.0);
  // float radius = 0.25 + sinusoid * 0.02;
  // float strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - radius));

  // // Pattern 46: perlin noise
  // float strength = cnoise(vUv * 10.0);

  // // Pattern 47: perlin noise (clean)
  // float strength = step(0.0, cnoise(vUv * 10.0));

  // // Pattern 48: perlin noise (neon)
  // float strength = 1.0 - abs(cnoise(vUv * 10.0));

  // // Pattern 49: perlin noise (wood)
  // float strength = sin(cnoise(vUv * 10.0) * 20.0);

  // // Pattern 50: perlin noise (sharp wood)
  // float strength = step(0.5, sin(cnoise(vUv * 10.0) * 20.0));
  // gl_FragColor = vec4(strength, strength, strength, 1.0);

  // ----- Mixed pattern -----
  float barX = step(0.4, mod(vUv.x * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0 + 0.2, 1.0));
  float barY = step(0.8, mod(vUv.x * 10.0 + 0.2, 1.0)) * step(0.4, mod(vUv.y * 10.0, 1.0));
  float strength = barX + barY;

  // Clamp the strength
  strength = clamp(strength, 0.0, 1.0);

  // Black and white
  vec3 blackColor = vec3(0.0);
  vec3 uvColor = vec3(vUv, 1.0);
  vec3 mixedColor = mix(blackColor, uvColor, strength);
  gl_FragColor = vec4(mixedColor, 1.0);
}