/* @license Enterprise */

import { Link } from 'react-router-dom';

import { SettingsPath } from 'twenty-shared/types';

import { currentWorkspaceState } from '@/auth/states/currentWorkspaceState';
import { SettingsCard } from '@/settings/components/SettingsCard';
import { SettingsSSOIdentitiesProvidersListCardWrapper } from '@/settings/security/components/SSO/SettingsSSOIdentitiesProvidersListCardWrapper';
import { SSOIdentitiesProvidersState } from '@/settings/security/states/SSOIdentitiesProvidersState';
import { useSnackBar } from '@/ui/feedback/snack-bar-manager/hooks/useSnackBar';
import { type ApolloError } from '@apollo/client';
import isPropValid from '@emotion/is-prop-valid';
import styled from '@emotion/styled';
import { useLingui } from '@lingui/react/macro';
import { useRecoilState, useRecoilValue } from 'recoil';
import { getSettingsPath } from 'twenty-shared/utils';
import { IconKey } from 'twenty-ui/display';
import { useGetSsoIdentityProvidersQuery } from '~/generated-metadata/graphql';

const StyledLink = styled(Link, {
  shouldForwardProp: (prop) => isPropValid(prop) && prop !== 'isDisabled',
})<{ isDisabled: boolean }>`
  pointer-events: ${({ isDisabled }) => (isDisabled ? 'none' : 'auto')};
  text-decoration: none;
`;

export const SettingsSSOIdentitiesProvidersListCard = () => {
  const { enqueueErrorSnackBar } = useSnackBar();

  const currentWorkspace = useRecoilValue(currentWorkspaceState);

  const { t } = useLingui();

  const [SSOIdentitiesProviders, setSSOIdentitiesProviders] = useRecoilState(
    SSOIdentitiesProvidersState,
  );

  const { loading } = useGetSsoIdentityProvidersQuery({
    fetchPolicy: 'network-only',
    skip: false, // Always fetch SSO data (removed enterprise restriction)
    onCompleted: (data) => {
      setSSOIdentitiesProviders(data?.getSSOIdentityProviders ?? []);
    },
    onError: (error: ApolloError) => {
      enqueueErrorSnackBar({
        apolloError: error,
      });
    },
  });

  return loading || !SSOIdentitiesProviders.length ? (
    <StyledLink
      to={getSettingsPath(SettingsPath.NewSSOIdentityProvider)}
      isDisabled={false} // SSO is now available for all users
    >
      <SettingsCard
        title={t`Add SSO Identity Provider`}
        disabled={false} // SSO is now available for all users
        Icon={<IconKey />}
      />
    </StyledLink>
  ) : (
    <SettingsSSOIdentitiesProvidersListCardWrapper />
  );
};
