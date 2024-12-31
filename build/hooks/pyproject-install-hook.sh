# Setup hook for Pyproject installer.
echo "Sourcing pyproject-install-hook"

pyprojectInstallPhase() {
  echo "Executing pyprojectInstallPhase"
  runHook preInstall

  pushd dist >/dev/null

  for wheel in ./*.whl; do
    @uv@/bin/uv pip install --offline --no-cache --no-deps --link-mode=copy --python=@pythonInterpreter@ --system --prefix "$out" $uvPipInstallFlags "$wheel"
    echo "Successfully installed $wheel"
  done

  rm -f "$out/.lock"

  popd >/dev/null

  runHook postInstall
  echo "Finished executing pyprojectInstallPhase"
}

if [ -z "${dontUsePyprojectInstall-}" ] && [ -z "${installPhase-}" ]; then
  echo "Using pyprojectInstallPhase"
  installPhase=pyprojectInstallPhase
fi
