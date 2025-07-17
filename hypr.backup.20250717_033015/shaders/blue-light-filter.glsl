precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    
    // Create a warm orange filter by reducing blue significantly and adjusting green
    pixColor.r *= 1.0;    // Keep red at full intensity
    pixColor.g *= 0.85;   // Reduce green slightly for more orange tint
    pixColor.b *= 0.4;    // Reduce blue more for warmer tone
    
    // Add slight saturation boost for richer colors
    float gray = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114));
    pixColor.rgb = mix(vec3(gray), pixColor.rgb, 1.1);
    
    gl_FragColor = pixColor;
}