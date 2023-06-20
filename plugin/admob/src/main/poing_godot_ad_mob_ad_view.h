// MIT License
//
// Copyright (c) 2023 Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#ifndef POING_GODOT_ADMOB_AD_VIEW_H
#define POING_GODOT_ADMOB_AD_VIEW_H

#include "core/version.h"

#if VERSION_4_0 == 4
#include "core/object/class_db.h"
#else
#include "core/object.h"
#endif

class PoingGodotAdMobAdView : public Object {

	GDCLASS(PoingGodotAdMobAdView, Object);

	static PoingGodotAdMobAdView *instance;
	static void _bind_methods();

public:
	void initialize();
	static PoingGodotAdMobAdView *get_singleton();

	PoingGodotAdMobAdView();
	~PoingGodotAdMobAdView();
};

#endif