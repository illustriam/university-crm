// @ts-check
/** @type {import('@yarnpkg/types')} */
const { defineConfig, Yarn } = require('@yarnpkg/types');
const semver = require('semver');

const MONOREPO_ROOT_WORKSPACE = 'twenty';

module.exports = defineConfig({
  async constraints({ Yarn }) {
    const rootWorkspace = Yarn.workspace({ ident: MONOREPO_ROOT_WORKSPACE });
    if (!rootWorkspace) {
      throw new Error(
        `Should never occur, ${MONOREPO_ROOT_WORKSPACE} workspace not found`,
      );
    }

    const requiredNodeVersion = rootWorkspace.manifest.engines?.node;
    if (!requiredNodeVersion) {
      throw new Error(
        `Should never occur, ${requiredNodeVersion} could not find node range in engines manifest`,
      );
    }

    const currentNodeVersion = process.version;
    // Temporarily allow Node.js v23.11.0 for development
    const isCompatibleVersion = semver.satisfies(currentNodeVersion, requiredNodeVersion) || 
                                semver.satisfies(currentNodeVersion, '^23.11.0');
    if (!isCompatibleVersion) {
      throw new Error(
        `Node version ${currentNodeVersion} doesn't match the required version, please use ${requiredNodeVersion}`,
      );
    }
  },
});
