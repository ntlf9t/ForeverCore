/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

// TrinityCore c19adebd44 builds game object rotations with G3D::Quat::fromYPRAngles instead of going through
// G3D::Matrix3::fromEulerAnglesZYX, and adds QuaternionData::fromOrientation. Every spawned or summoned object's
// rotation goes through these: the rotation they describe must stay the same.

#include "tc_catch2.h"
#include "QuaternionData.h"
#include <G3D/Matrix3.h>
#include <G3D/Quat.h>
#include <cmath>

namespace
{
constexpr float Pi = 3.14159265358979323846f;

G3D::Matrix3 ToMatrix(QuaternionData const& q)
{
    return G3D::Matrix3(G3D::Quat(q.x, q.y, q.z, q.w));
}

bool SameRotation(G3D::Matrix3 const& a, G3D::Matrix3 const& b)
{
    for (int r = 0; r < 3; ++r)
        for (int c = 0; c < 3; ++c)
            if (std::abs(a[r][c] - b[r][c]) > 1e-5f)
                return false;
    return true;
}
}

TEST_CASE("fromEulerAnglesZYX describes the same rotation as Matrix3::fromEulerAnglesZYX", "[QuaternionData]")
{
    for (float z = -Pi; z <= Pi; z += Pi / 7.f)
        for (float y = -Pi / 2.f + 0.05f; y <= Pi / 2.f - 0.05f; y += Pi / 9.f)
            for (float x = -Pi; x <= Pi; x += Pi / 5.f)
            {
                QuaternionData const q = QuaternionData::fromEulerAnglesZYX(z, y, x);
                INFO("z " << z << " y " << y << " x " << x);
                CHECK(q.isUnit());
                CHECK(SameRotation(ToMatrix(q), G3D::Matrix3::fromEulerAnglesZYX(z, y, x)));
            }
}

TEST_CASE("toEulerAnglesZYX gives back the angles", "[QuaternionData]")
{
    for (float z = -Pi + 0.1f; z < Pi; z += Pi / 7.f)
        for (float y = -Pi / 2.f + 0.1f; y < Pi / 2.f - 0.1f; y += Pi / 9.f)
            for (float x = -Pi + 0.1f; x < Pi; x += Pi / 5.f)
            {
                float rz = 0.f, ry = 0.f, rx = 0.f;
                QuaternionData::fromEulerAnglesZYX(z, y, x).toEulerAnglesZYX(rz, ry, rx);
                INFO("z " << z << " y " << y << " x " << x);
                CHECK(SameRotation(G3D::Matrix3::fromEulerAnglesZYX(rz, ry, rx), G3D::Matrix3::fromEulerAnglesZYX(z, y, x)));
            }
}

TEST_CASE("fromOrientation is a turn about Z only", "[QuaternionData]")
{
    for (float o = 0.f; o < 2.f * Pi; o += Pi / 12.f)
    {
        QuaternionData const q = QuaternionData::fromOrientation(o);
        INFO("o " << o);
        CHECK(q.isUnit());
        CHECK(q.x == 0.f);
        CHECK(q.y == 0.f);
        CHECK(SameRotation(ToMatrix(q), G3D::Matrix3::fromEulerAnglesZYX(o, 0.f, 0.f)));
    }
}
