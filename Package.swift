// swift-tools-version: 5.9

import PackageDescription

#if compiler(>=6)
    let swiftVersion = [SwiftLanguageMode.version("6")]
#else
    let swiftVersion = [SwiftVersion.v5]
#endif

var sources = [
    "llama.cpp/ggml/src/ggml.c",
    "llama.cpp/ggml/src/gguf.cpp",
    "llama.cpp/ggml/src/ggml-quants.c",
    "llama.cpp/ggml/src/ggml-alloc.c",
    "llama.cpp/ggml/src/ggml-backend.cpp",
    "llama.cpp/ggml/src/ggml-threading.cpp",
    "llama.cpp/ggml/src/ggml-backend-reg.cpp",
    "llama.cpp/ggml/src/ggml-metal/ggml-metal.m",
    "llama.cpp/ggml/src/ggml-blas/ggml-blas.cpp",
    "llama.cpp/ggml/src/ggml-aarch64.c",
    "llama.cpp/ggml/src/ggml-cpu/ggml-cpu-aarch64.c",
    "llama.cpp/ggml/src/ggml-cpu/ggml-cpu.c",
    "llama.cpp/ggml/src/ggml-cpu/ggml-cpu.cpp",
    "llama.cpp/ggml/src/ggml-cpu/ggml-cpu-quants.c",
    "llama.cpp/ggml/src/ggml-cpu/ggml-cpu-traits.cpp",
    "llama.cpp/ggml/src/ggml-cpu/llamafile/sgemm.cpp",
    "llama.cpp/src/llama.cpp",
    "llama.cpp/src/unicode.cpp",
    "llama.cpp/src/unicode-data.cpp",
    "llama.cpp/src/llama-grammar.cpp",
    "llama.cpp/src/llama-vocab.cpp",
    "llama.cpp/src/llama-sampling.cpp",
    "llama.cpp/src/llama-context.cpp",
    "llama.cpp/src/llama-kv-cache.cpp",
    "llama.cpp/src/llama-mmap.cpp",
    "llama.cpp/src/llama-quant.cpp",
    "llama.cpp/src/llama-model.cpp",
    "llama.cpp/src/llama-model-loader.cpp",
    "llama.cpp/src/llama-impl.cpp",
    "llama.cpp/src/llama-cparams.cpp",
    "llama.cpp/src/llama-hparams.cpp",
    "llama.cpp/src/llama-chat.cpp",
    "llama.cpp/src/llama-batch.cpp",
    "llama.cpp/src/llama-arch.cpp",
    "llama.cpp/src/llama-adapter.cpp",
    "llama.cpp/common/common.cpp",
    "llama.cpp/common/log.cpp",
    "llama.cpp/common/arg.cpp",
    "llama.cpp/common/json-schema-to-grammar.cpp",
    "llama.cpp/common/sampling.cpp",
    "llama.cpp/examples/llava/llava.cpp",
    "llama.cpp/examples/llava/clip.cpp",
    "llama.cpp/examples/llava/llava-cli.cpp",
]

var cSettings: [CSetting] = [
    .define("SWIFT_PACKAGE"),
    .define("GGML_USE_ACCELERATE"),
    .define("GGML_BLAS_USE_ACCELERATE"),
    .define("ACCELERATE_NEW_LAPACK"),
    .define("ACCELERATE_LAPACK_ILP64"),
    .define("GGML_USE_BLAS"),
    .define("GGML_USE_LLAMAFILE"),
    .define("GGML_METAL_NDEBUG"),
    .define("NDEBUG"),
    .define("GGML_USE_CPU"),
    .define("GGML_USE_METAL"),
    .unsafeFlags(["-O3"], .when(configuration: .debug)),
    .unsafeFlags(["-mfma", "-mfma", "-mavx", "-mavx2", "-mf16c", "-msse3", "-mssse3"]),
    .unsafeFlags(["-pthread"]),
    .unsafeFlags(["-fno-objc-arc"]),
    .unsafeFlags(["-Wno-shorten-64-to-32"]),
    .unsafeFlags(["-fno-finite-math-only"], .when(configuration: .release)),
//    .unsafeFlags(["-w"]), // ignore all warnings

    .headerSearchPath("llama.cpp/common"),
    .headerSearchPath("llama.cpp/include"),
    .headerSearchPath("llama.cpp/ggml/include"),
    .headerSearchPath("llama.cpp/ggml/src"),
    .headerSearchPath("llama.cpp/ggml/src/ggml-cpu"),
]

var linkerSettings: [LinkerSetting] = [
    .linkedFramework("Foundation"),
    .linkedFramework("Accelerate"),
    .linkedFramework("Metal"),
    .linkedFramework("MetalKit"),
    .linkedFramework("MetalPerformanceShaders"),
]

var resources: [Resource] = [
    .process("llama.cpp/ggml/src/ggml-metal.metal"),
]

let package = Package(
    name: "llama.cpp.swift",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "llama.cpp.swift",
            targets: ["llama.cpp.swift"]
        ),
    ],
    targets: [
        .target(
            name: "llama.cpp.swift",
            sources: sources,
            resources: resources,
            cSettings: cSettings,
            linkerSettings: linkerSettings
        ),
//        .target(
//            name: "llama.cpp.swift.core",
//            sources: sources,
//            resources: resources,
//            cSettings: cSettings,
//            linkerSettings: linkerSettings
//        ),
        .testTarget(
            name: "llama.cpp.swiftTests",
            dependencies: ["llama.cpp.swift"]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
