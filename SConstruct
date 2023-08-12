#!/usr/bin/env python
import os
import sys
import subprocess

if sys.version_info < (3,):
    def decode_utf8(x):
        return x
else:
    import codecs
    def decode_utf8(x):
        return codecs.utf_8_decode(x)[0]

# Most of the settings are taken from https://github.com/BastiaanOlij/gdnative_cpp_example

opts = Variables([], ARGUMENTS)

# Gets the standard flags CC, CCX, etc.
env = DefaultEnvironment()

# Define our options
opts.Add(EnumVariable('target', "Compilation target", 'debug', ['debug', 'release', "release_debug"]))
opts.Add(EnumVariable('arch', "Compilation Architecture", '', ['', 'arm64', 'armv7', 'x86_64']))
opts.Add(BoolVariable('simulator', "Compilation platform", 'no'))
opts.Add(BoolVariable('use_llvm', "Use the LLVM / Clang compiler", 'no'))
opts.Add(PathVariable('target_path', 'The path where the lib is installed.', 'bin/static_libraries/'))
opts.Add(EnumVariable('plugin', 'Plugin to build', '', ['', 'ads', 'adcolony', 'meta', 'vungle']))

# Updates the environment with the option variables.
opts.Update(env)

# Process some arguments
if env['use_llvm']:
    env['CC'] = 'clang'
    env['CXX'] = 'clang++'

if env['arch'] == '':
    print("No valid arch selected.")
    quit();

if env['plugin'] == '':
    print("No valid plugin selected.")
    quit();

# For the reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# Enable Obj-C modules
env.Append(CCFLAGS=["-fmodules", "-fcxx-modules"])
xcframework_directory = ''

if env['simulator']:
    xcframework_directory = 'ios-arm64_x86_64-simulator'
    sdk_name = 'iphonesimulator'
    env.Append(CCFLAGS=['-mios-simulator-version-min=10.0'])
    env.Append(LINKFLAGS=["-mios-simulator-version-min=10.0"])
else:
    xcframework_directory = 'ios-arm64'
    sdk_name = 'iphoneos'
    env.Append(CCFLAGS=['-miphoneos-version-min=10.0'])
    env.Append(LINKFLAGS=["-miphoneos-version-min=10.0"])

#need to perform `cd PoingGodotAdMob && pod install --repo-update`
env.Append(FRAMEWORKPATH=['#PoingGodotAdMob/Pods/Google-Mobile-Ads-SDK/Frameworks/GoogleMobileAdsFramework/GoogleMobileAds.xcframework/' + xcframework_directory])

if env['plugin'] == 'ads':
    env.Append(FRAMEWORKPATH=['#PoingGodotAdMob/Pods/GoogleUserMessagingPlatform/Frameworks/Release/UserMessagingPlatform.xcframework/' + xcframework_directory])
elif env['plugin'] == 'adcolony':
    if env['simulator']:
        xcframework_directory_adcolony = 'ios-arm64_i386_x86_64-simulator'
        xcframework_directory_adcolony_adapter = 'ios-arm64_x86_64-simulator'
    else:
        xcframework_directory_adcolony = 'ios-arm64_armv7'
        xcframework_directory_adcolony_adapter = 'ios-arm64_armv7'
        
    env.Append(FRAMEWORKPATH=['#PoingGodotAdMob/Pods/AdColony/AdColony.xcframework/' + xcframework_directory_adcolony])
    env.Append(FRAMEWORKPATH=['#PoingGodotAdMob/Pods/GoogleMobileAdsMediationAdColony/AdColonyAdapter-4.9.0.2/AdColonyAdapter.xcframework/' + xcframework_directory_adcolony_adapter])
    
elif env['plugin'] == 'meta':
    if env['simulator']:
        xcframework_directory_meta = 'ios-arm64_x86_64-simulator'
        xcframework_directory_meta_adapter = 'ios-arm64_x86_64-simulator'
    else:
        xcframework_directory_meta = 'ios-arm64_armv7'
        xcframework_directory_meta_adapter = 'ios-arm64_armv7'
        
    env.Append(FRAMEWORKPATH=['#PoingGodotAdMob/Pods/FBAudienceNetwork/Static/FBAudienceNetwork.xcframework/' + xcframework_directory_meta])
    env.Append(FRAMEWORKPATH=['#PoingGodotAdMob/Pods/GoogleMobileAdsMediationFacebook/MetaAdapter-6.12.0.1/MetaAdapter.xcframework/' + xcframework_directory_meta_adapter])
elif env['plugin'] == 'vungle':
    if env['simulator']:
        xcframework_directory_adcolony = 'ios-arm64_i386_x86_64-simulator'
        xcframework_directory_adcolony_adapter = 'ios-x86_64-simulator'
    else:
        xcframework_directory_adcolony = 'ios-arm64_armv7'
        xcframework_directory_adcolony_adapter = 'ios-arm64_armv7'
        
    env.Append(FRAMEWORKPATH=['#PoingGodotAdMob/Pods/VungleSDK-iOS/VungleSDK.xcframework/' + xcframework_directory_adcolony])
    env.Append(FRAMEWORKPATH=['#PoingGodotAdMob/Pods/GoogleMobileAdsMediationVungle/VungleAdapter-6.12.3.0/VungleAdapter.xcframework/' + xcframework_directory_adcolony_adapter])





try:
    sdk_path = decode_utf8(subprocess.check_output(['xcrun', '--sdk', sdk_name, '--show-sdk-path']).strip())
except (subprocess.CalledProcessError, OSError):
    raise ValueError("Failed to find SDK path while running xcrun --sdk {} --show-sdk-path.".format(sdk_name))

env.Append(CCFLAGS=[
    '-fobjc-arc', 
    '-fmessage-length=0', '-fno-strict-aliasing', '-fdiagnostics-print-source-range-info', 
    '-fdiagnostics-show-category=id', '-fdiagnostics-parseable-fixits', '-fpascal-strings', 
    '-fblocks', '-fvisibility=hidden', '-MMD', '-MT', 'dependencies', '-fno-exceptions', 
    '-Wno-ambiguous-macro', 
    '-Wall', '-Werror=return-type',
    # '-Wextra',
])

env.Append(CCFLAGS=['-arch', env['arch'], "-isysroot", "-stdlib=libc++", '-isysroot', sdk_path])
env.Append(CCFLAGS=['-DPTRCALL_ENABLED'])
env.Prepend(CXXFLAGS=[
    '-DNEED_LONG_INT', '-DLIBYUV_DISABLE_NEON', 
    '-DUNIX_ENABLED', '-DCOREAUDIO_ENABLED'
])
env.Append(LINKFLAGS=["-arch", env['arch'], '-isysroot', sdk_path, '-F' + sdk_path])

if env['arch'] == 'armv7':
    env.Prepend(CXXFLAGS=['-fno-aligned-allocation'])

env.Append(CCFLAGS=["$IOS_SDK_PATH"])
env.Prepend(CXXFLAGS=['-DIOS_ENABLED'])
env.Prepend(CXXFLAGS=['-DVERSION_4_0'])

env.Prepend(CFLAGS=['-std=gnu11'])
env.Prepend(CXXFLAGS=['-std=gnu++17'])

if env['target'] == 'debug':
    env.Prepend(CXXFLAGS=[
        '-gdwarf-2', '-O0', 
        '-DDEBUG_MEMORY_ALLOC', '-DDISABLE_FORCED_INLINE', 
        '-D_DEBUG', '-DDEBUG=1', '-DDEBUG_ENABLED', 
    ])
elif env['target'] == 'release_debug':
    env.Prepend(CXXFLAGS=[
        '-O2', '-ftree-vectorize',
        '-DNDEBUG', '-DNS_BLOCK_ASSERTIONS=1', '-DDEBUG_ENABLED',
    ])

    if env['arch'] != 'armv7':
        env.Prepend(CXXFLAGS=['-fomit-frame-pointer'])
else:
    env.Prepend(CXXFLAGS=[
        '-O2', '-ftree-vectorize',
        '-DNDEBUG', '-DNS_BLOCK_ASSERTIONS=1',
    ])

    if env['arch'] != 'armv7':
        env.Prepend(CXXFLAGS=['-fomit-frame-pointer'])            

env.Append(CPPPATH=[
    '.', 
    'godot', 
    'godot/platform/ios',
])

# tweak this if you want to use different folders, or more folders, to store your source code in.
if env['plugin'] == 'ads':
    sources = Glob('PoingGodotAdMob/src/' + env['plugin'] + '/*.mm')
    sources.append(Glob('PoingGodotAdMob/src/' + env['plugin'] + '/adformats/*.mm'))
    sources.append(Glob('PoingGodotAdMob/src/' + env['plugin'] + '/helpers/*.mm'))
    sources.append(Glob('PoingGodotAdMob/src/' + env['plugin'] + '/converters/*.mm'))
    sources.append(Glob('PoingGodotAdMob/src/' + env['plugin'] + '/ump/*.mm'))
else:
    sources = Glob('PoingGodotAdMob/src/mediation/' + env['plugin'] + '/*.mm')


# lib<plugin>.<arch>-<simulator|ios>.<release|debug|release_debug>.a
library_platform = env["arch"] + "-" + ("simulator" if env["simulator"] else "ios")
print(library_platform)
library_name = "poing-godot-admob-" + env['plugin'] + "." + library_platform + "." + env["target"] + ".a"
library = env.StaticLibrary(target=env['target_path'] + env['plugin'] + "/" + library_name, source=sources)

Default(library)

# Generates help for the -h scons option.
Help(opts.GenerateHelpText(env))