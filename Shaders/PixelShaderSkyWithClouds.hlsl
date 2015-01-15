//// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
//// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//// PARTICULAR PURPOSE.
////
//// Copyright (c) Microsoft Corporation. All rights reserved

#include "ConstantBuffers.hlsli"


//these make things darker.
float4 Darken(float4 cBase, float4 cBlend)
{
	float4 cNew;
	cNew.rgb = min(cBase.rgb, cBlend.rgb);
	cNew.a = 1.0;
	return cNew;
}

float4 Multiply(float4 cBase, float4 cBlend)
{
	return (cBase * cBlend);
}

float4 ColorBurn(float4 cBase, float4 cBlend)
{
	return (1 - (1 - cBase) / cBlend);
}

float4 LinearBurn(float4 cBase, float4 cBlend)
{
	return (cBase + cBlend - 1);
}


//these make things lighter
float4 Lighten(float4 cBase, float4 cBlend)
{
	float4 cNew;
	cNew.rgb = max(cBase.rgb, cBlend.rgb);
	cNew.a = 1.0;
	return cNew;
}
float4 Screen(float4 cBase, float4 cBlend)
{
	return (1 - (1 - cBase) * (1 - cBlend));
}
float4 ColorDodge(float4 cBase, float4 cBlend)
{
	return (cBase / (1 - cBlend));
}
float4 LinearDodge(float4 cBase, float4 cBlend)
{
	return (cBase + cBlend);
}

//Comparisson functions
float4 Difference(float4 cBase, float4 cBlend)
{
	return (abs(cBase - cBlend));
}
float4 Exclusion(float4 cBase, float4 cBlend)
{
	return (.5 - 2 * (cBase - .5) * (cBlend - .5));
}


//Complex Functions
float4 Overlay(float4 cBase, float4 cBlend)
{
	/*
	float4 cNew;
	if (cBase.r > .5) { cNew.r = 1 - (1 - 2 * (cBase.r - .5)) * (1 - cBlend.r); }
	else { cNew.r = (2 * cBase.r) * cBlend.r; }

	if (cBase.g > .5) { cNew.g = 1 - (1 - 2 * (cBase.g - .5)) * (1 - cBlend.g); }
	else { cNew.g = (2 * cBase.g) * cBlend.g; }

	if (cBase.b > .5) { cNew.b = 1 - (1 - 2 * (cBase.b - .5)) * (1 - cBlend.b); }
	else { cNew.b = (2 * cBase.b) * cBlend.b; }

	cNew.a = 1.0;
	return cNew;
	*/
	// Vectorized (easier for compiler)
	float4 cNew;

	// overlay has two output possbilities
	// which is taken is decided if pixel value
	// is below half or not

	cNew = step(0.5, cBase);

	// we pick either solution
	// depending on pixel

	// first is case of < 0.5
	// second is case for >= 0.5

	// interpolate between the two, 
	// using color as influence value
	cNew = lerp((cBase*cBlend * 2), (1.0 - (2.0*(1.0 - cBase)*(1.0 - cBlend))), cNew);

	cNew.a = 1.0;
	return cNew;
}
float4 SoftLight(float4 cBase, float4 cBlend)
{
	float4 cNew;
	if (cBlend.r > .5) { cNew.r = cBase.r * (1 - (1 - cBase.r) * (1 - 2 * (cBlend.r))); }
	else { cNew.r = 1 - (1 - cBase.r) * (1 - (cBase.r * (2 * cBlend.r))); }

	if (cBlend.g > .5) { cNew.g = cBase.g * (1 - (1 - cBase.g) * (1 - 2 * (cBlend.g))); }
	else { cNew.g = 1 - (1 - cBase.g) * (1 - (cBase.g * (2 * cBlend.g))); }

	if (cBlend.g > .5) { cNew.b = cBase.b * (1 - (1 - cBase.b) * (1 - 2 * (cBlend.b))); }
	else { cNew.b = 1 - (1 - cBase.b) * (1 - (cBase.b * (2 * cBlend.b))); }

	cNew.a = 1.0;
	return cNew;
}
float4 HardLight(float4 cBase, float4 cBlend)
{
	float4 cNew;
	if (cBlend.r > .5) { cNew.r = 1 - (1 - cBase.r) * (1 - 2 * (cBlend.r)); }
	else { cNew.r = cBase.r * (2 * cBlend.r); }

	if (cBlend.g > .5) { cNew.g = 1 - (1 - cBase.g) * (1 - 2 * (cBlend.g)); }
	else { cNew.g = cBase.g * (2 * cBlend.g); }

	if (cBlend.b > .5) { cNew.b = 1 - (1 - cBase.b) * (1 - 2 * (cBlend.b)); }
	else { cNew.b = cBase.b * (2 * cBlend.b); }

	cNew.a = 1.0;
	return cNew;
}
float4 VividLight(float4 cBase, float4 cBlend)
{
	float4 cNew;
	if (cBlend.r > .5) { cNew.r = 1 - (1 - cBase.r) / (2 * (cBlend.r - .5)); }
	else { cNew.r = cBase.r / (1 - 2 * cBlend.r); }

	if (cBlend.g > .5) { cNew.g = 1 - (1 - cBase.g) / (2 * (cBlend.g - .5)); }
	else { cNew.g = cBase.g / (1 - 2 * cBlend.g); }

	if (cBlend.b > .5) { cNew.b = 1 - (1 - cBase.b) / (2 * (cBlend.b - .5)); }
	else { cNew.b = cBase.b / (1 - 2 * cBlend.b); }

	cNew.a = 1.0;
	return cNew;
}
float4 LinearLight(float4 cBase, float4 cBlend)
{
	float4 cNew;
	if (cBlend.r > .5) { cNew.r = cBase.r + 2 * (cBlend.r - .5); }
	else { cNew.r = cBase.r + 2 * cBlend.r - 1; }

	if (cBlend.g > .5) { cNew.g = cBase.g + 2 * (cBlend.g - .5); }
	else { cNew.g = cBase.g + 2 * cBlend.g - 1; }

	if (cBlend.b > .5) { cNew.b = cBase.b + 2 * (cBlend.b - .5); }
	else { cNew.b = cBase.b + 2 * cBlend.b - 1; }

	cNew.a = 1.0;
	return cNew;
}
float4 PinLight(float4 cBase, float4 cBlend)
{
	float4 cNew;
	if (cBlend.r > .5) { cNew.r = max(cBase.r, 2 * (cBlend.r - .5)); }
	else { cNew.r = min(cBase.r, 2 * cBlend.r); }

	if (cBlend.g > .5) { cNew.g = max(cBase.g, 2 * (cBlend.g - .5)); }
	else { cNew.g = min(cBase.g, 2 * cBlend.g); }

	if (cBlend.b > .5) { cNew.b = max(cBase.b, 2 * (cBlend.b - .5)); }
	else { cNew.b = min(cBase.b, 2 * cBlend.b); }

	cNew.a = 1.0;
	return cNew;
}

float4 Thermal(float4 cBase)
{
	float3 thermal = float3(1.0, 0.0, 0.0);
	float3 colors[3];
	colors[0] = float3(0., 0., 1.);
	colors[1] = float3(1., 1., 0.);
	colors[2] = float3(1., 0., 0.);
	float lum = dot(float3(0.30, 0.59, 0.11), cBase.rgb);
	int ix = (lum < 0.5) ? 0 : 1;
	thermal = lerp(colors[ix], colors[ix + 1], (lum - float(ix)*0.5) / 0.5);
	return float4(thermal, 1.0);
}

float4 RadialBlur(float4 cBase, PixelShaderSkyWithCloudsInput input)
{
	//radial blur
	float3 Center = { 0.5, 0.5, 0.5 }; ///center of the screen (could be any place)
	float BlurStart = 2.0f; /// blur offset
	float BlurWidth = -0.1; ///how big it should be
	int nsamples = 10;
	float3 UV = input.texCoord;
		UV -= Center;
	float4 c = 0;
	for (int i = 0; i < nsamples; i++) {
		float scale = BlurStart + BlurWidth*(i / (float)(nsamples - 1));
		c += skyMap.Sample(linearSampler, input.texCoord * scale + Center);
	}
	c /= nsamples;
	return c;
}

float4 Emboss(float4 cBase, PixelShaderSkyWithCloudsInput input)
{
	float size = 0.003;
	
	float4 color = float4(0.5,0.5,0.5,1.0);
	color -= skyMap.Sample(linearSampler, input.texCoord - size) * 5.0;
	color += skyMap.Sample(linearSampler, input.texCoord + size) * 5.0;
	float avgColor = (color.r + color.g + color.b) / 3.0;
	
	return float4(avgColor, avgColor, avgColor, 1);

}
//------------------------------------------------------------
//  Main pixel shader
//-----------------------------------------------------------

float4 main(PixelShaderSkyWithCloudsInput input) : SV_Target
{
	float4 color = skyMap.Sample(linearSampler, input.texCoord);

	//original
	return color;

	//Artistic Effects:

	//darken
	//float4 mask = float4(0.0,0.0,0.0,0.0);
	//float4 mask = float4(0.0, 0.0, 1.0, 0.0);
	//float4 mask = float4(0.5, 0.5, 0.5, 0.0);
	//return Darken(color, mask);

	//multiply
	//float4 mask = float4(0.0, 0.0, 0.0, 0.0);
	//float4 mask = float4(0, 0.0, 1.0, 0.0);
	//float4 mask = float4(0.5, 0.5, 0.5, 0.0);
	//return Multiply(color, mask);


	//color burn
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 0.5, 0.0);
	//float4 mask = float4(0.75, 0.75, 0.75, 0.75);
	//return ColorBurn(color, mask);

	//linear burn
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 0.5, 0.0);
	//float4 mask = float4(0.75, 0.75, 0.75, 0.75);
	//return LinearBurn(color, mask);

	//Lighten
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 0.5, 0.0);
	//float4 mask = float4(0.75, 0.75, 0.75, 0.75);
	//return Lighten(color, mask);

	//Screen
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 0.5, 0.0);
	//float4 mask = float4(0.75, 0.75, 0.75, 0.75);
	//return Screen(color, mask);

	//ColorDodge
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 0.5, 0.0);
	//float4 mask = float4(0.75, 0.75, 0.75, 0.75);
	//return ColorDodge(color, mask);


	//LinearDodge
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 0.5, 0.0);
	//float4 mask = float4(0.75, 0.75, 0.75, 0.75);
	//return LinearDodge(color, mask);

	//Difference
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 0.5, 0.0);
	//float4 mask = float4(0.75, 0.75, 0.75, 0.75);
	//return Difference(color, mask);

	//Exclusion
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 1.0, 0.0);
	//float4 mask = float4(1.0, 1.0, 1.0, 1.0);
	//return Exclusion(color, mask);

	//crazy sunrise
	//return ColorBurn(color, mul(fmod(playingTime+0.01, 25), 0.04));

	//whiteout or expanding clouds with the randomized input
	//float density = clamp(mul(fmod(mul(input.cloudLayer.x, 5) + playingTime, 25), 0.04), 0, 0.5);
	//float4 cloudColor = float4(density, density, density, 1.0f);
	//return Lighten(color, cloudColor);

	//Common Style Shaders:
	//Overlay
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 1.0, 0.0);
	//float4 mask = float4(1.0, 1.0, 1.0, 1.0);
	//return Overlay(color,mask);

	//SoftLight
	//float4 mask = float4(0.01, 0.01, 0.01, 0.01);
	//float4 mask = float4(0.0, 0.0, 0.6, 0.0);
	//float4 mask = float4(1.0, 1.0, 1.0, 1.0);
	//return SoftLight(color, mask);

	//HardLight
	//float4 mask = float4(0.05, 0.05, 0.05, 0.05);
	//float4 mask = float4(0.01, 0.01, 0.4, 0.01);
	//float4 mask = float4(1.0, 1.0, 1.0, 1.0);
	//return HardLight(color, mask);


	//VividLight
	//float4 mask = float4(0.01, 0.01, 0.01, 1.0);
	//float4 mask = float4(0.0, 0.9, 0.0, 1.0);
	//float4 mask = float4(0.90, 0.90, 0.50, 1.0);
	//return VividLight(color, mask);

	//LinearLight
	//float4 mask = float4(0.05, 0.05, 0.05, 1.0);
	//float4 mask = float4(0.0, 0.9, 0.0, 1.0);
	//float4 mask = float4(0.85, 0.85, 0.85, 1.0);
	//return LinearLight(color, mask);

	//PinLight
	//float4 mask = float4(0.05, 0.05, 0.05, 1.0);
	//float4 mask = float4(0.0, 0.6, 0.0, 1.0);
	//float4 mask = float4(0.75, 0.75, 0.75, 1.0);
	//return PinLight(color, mask);

	//Thermal vision
	//return Thermal(color);

	//Radial Blur
	//return RadialBlur(color,input);

	//Emboss
	//return Emboss(color,input);
}


