//// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
//// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//// PARTICULAR PURPOSE.
////
//// Copyright (c) Microsoft Corporation. All rights reserved

#pragma once

// Sphere:
// This class is a specialization of GameObject that represents a sphere primitive.
// The sphere is defined by a 'position' and radius.

#include "GameObject.h"

ref class Sphere: public GameObject
{
internal:
    Sphere();
    Sphere(DirectX::XMFLOAT3 pos, float radius);

    void Position(DirectX::XMFLOAT3 position);
    void Position(DirectX::XMVECTOR position);
    void Radius(float radius);
    float Radius();

private:
    void Update();

    float m_radius;
};


__forceinline void Sphere::Position(DirectX::XMFLOAT3 position)
{
    m_position = position;
    Update();
}

__forceinline void Sphere::Position(DirectX::XMVECTOR position)
{
    DirectX::XMStoreFloat3(&m_position, position);
    Update();
}

__forceinline void Sphere::Radius(float radius)
{
    m_radius = radius;
    Update();
}

__forceinline float Sphere::Radius()
{
    return m_radius;
}