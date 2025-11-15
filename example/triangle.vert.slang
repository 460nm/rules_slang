[shader("vertex")]
float4 main(uint vertexID : SV_VertexID) : SV_Position
{
    float x = (vertexID == 0) ? -0.5 : ((vertexID == 1) ? 0.5 : 0.0);
    float y = (vertexID == 2) ? 0.5 : -0.5;
    
    return float4(x, y, 0.0, 1.0);
}

