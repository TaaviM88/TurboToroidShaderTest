#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile _ _SHADOWS_SOFT

void MainLight_float(float3 WorldPos, out float3 Direction, out float3 Color,
    out float DistanceAtten, out float ShadowAtten) {

#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(1, 1, -0.4));
    Color = float4(1, 1, 1, 1);
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
    Light mainLight = GetMainLight();
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;

    float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    // or if you want shadow cascades :
    // half cascadeIndex = ComputeCascadeIndex(WorldPos);
    // float4 shadowCoord = mul(_MainLightWorldToShadow[cascadeIndex], float4(WorldPos, 1.0));

    ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
    float shadowStrength = GetMainLightShadowStrength();
    ShadowAtten = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), shadowSamplingData, shadowStrength, false);
#endif
}

void MainLight_half(half3 WorldPos, out half3 Direction, out half3 Color,
    out half DistanceAtten, out half ShadowAtten)
{
#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(half3(0.5f, 0.5f, 0.25f));
    Color = half3(1.0f, 1.0f, 1.0f);
    DistanceAtten = 1.0f;
    ShadowAtten = 1.0f;
#else
    half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    Light mainLight = GetMainLight(shadowCoord);

    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif
}

void AdditionalLight_float(float3 WorldPos, int Index, out float3 Direction,
    out float3 Color, out float DistanceAtten, out float ShadowAtten)
{
    Direction = normalize(float3(0.5f, 0.5f, 0.25f));
    Color = float3(0.0f, 0.0f, 0.0f);
    DistanceAtten = 0.0f;
    ShadowAtten = 0.0f;

#ifndef SHADERGRAPH_PREVIEW
    int pixelLightCount = GetAdditionalLightsCount();
    if (Index < pixelLightCount)
    {
        Light light = GetAdditionalLight(Index, WorldPos);

        Direction = light.direction;
        Color = light.color;
        DistanceAtten = light.distanceAttenuation;
        ShadowAtten = light.shadowAttenuation;
    }
#endif
}

void AdditionalLight_half(half3 WorldPos, int Index, out half3 Direction,
    out half3 Color, out half DistanceAtten, out half ShadowAtten)
{
    Direction = normalize(half3(0.5f, 0.5f, 0.25f));
    Color = half3(0.0f, 0.0f, 0.0f);
    DistanceAtten = 0.0f;
    ShadowAtten = 0.0f;

#ifndef SHADERGRAPH_PREVIEW
    int pixelLightCount = GetAdditionalLightsCount();
    if (Index < pixelLightCount)
    {
        Light light = GetAdditionalLight(Index, WorldPos);

        Direction = light.direction;
        Color = light.color;
        DistanceAtten = light.distanceAttenuation;
        ShadowAtten = light.shadowAttenuation;
    }
#endif
}
